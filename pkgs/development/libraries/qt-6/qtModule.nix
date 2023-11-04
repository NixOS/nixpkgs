{ lib
, stdenv
, cmake
, ninja
, perl
, moveBuildTree
, srcs
, patches ? [ ]
, pkgsBuildHost
}:

args:

let
  inherit (args) pname;
  version = args.version or srcs.${pname}.version;
  src = args.src or srcs.${pname}.src;
in
(stdenv.mkDerivation ((builtins.removeAttrs args [ "dontIgnorePath" "nativeQtBuildInputs" ]) // {
  inherit pname version src;
  patches = args.patches or patches.${pname} or [ ];

  buildInputs = args.buildInputs or [ ];
  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ cmake ninja perl ]
    ++ lib.optionals stdenv.isDarwin [ moveBuildTree ];
  propagatedBuildInputs =
    (lib.warnIf (args ? qtInputs) "qt6.qtModule's qtInputs argument is deprecated" args.qtInputs or []) ++
    (args.propagatedBuildInputs or []);

  moveToDev = false;

  outputs = args.outputs or [ "out" "dev" ];

  dontWrapQtApps = args.dontWrapQtApps or true;

  meta = with lib; {
    homepage = "https://www.qt.io/";
    description = "A cross-platform application framework for C++";
    license = with licenses; [ fdl13Plus gpl2Plus lgpl21Plus lgpl3Plus ];
    maintainers = with maintainers; [ milahu nickcao ];
    platforms = platforms.unix;
  } // (args.meta or { });
}))
  .overrideAttrs(previousAttrs: lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) {
    strictDeps = true;
    env = (previousAttrs.env or {}) // { QT_HOST_PATH = "${pkgsBuildHost.qt6Packages.qtbase}"; };
    cmakeFlags = [
      "-DQT_FORCE_BUILD_TOOLS=true"
    ] ++ lib.optionals (!(args.dontIgnorePath or false)) [
      # When cross-compiling, QT's build process will ignore the
      # $PATH, assuming a conventional FHS distro, all QT packages
      # smashed together into a single installation directory, and
      # poor hygiene on the part of the developer.  Since we carefully
      # manage our $PATH and install each package to a separate prefix
      # it's okay for QT to trust the $PATH we expose to it.
      #
      # The bizzarrely-named
      # `QT_DISABLE_NO_DEFAULT_PATH_IN_QT_PACKAGES` option is how you
      # tell QT that we are smarter than it is.
      #
      # See: https://codereview.qt-project.org/gitweb?p=qt%2Fqtbase.git;a=commit;h=7bb91398f25cb2016c0558fd397b376f413e3e96
      # TODO: set this globally, everywhere.
      "-DQT_DISABLE_NO_DEFAULT_PATH_IN_QT_PACKAGES=true"
    ] ++ lib.optional (args?nativeQtBuildInputs)
      ("-DQT_ADDITIONAL_HOST_PACKAGES_PREFIX_PATH=${
        lib.concatMapStringsSep ":"
          (pname: pkgsBuildHost.qt6Packages.${pname})
          args.nativeQtBuildInputs}")
    ++ (previousAttrs.cmakeFlags or []);
  })

