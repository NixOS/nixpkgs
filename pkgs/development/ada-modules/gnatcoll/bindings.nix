{
  stdenv,
  lib,
  fetchFromGitHub,
  gnat,
  gprbuild,
  gnatcoll-core,
  component,
  # component dependencies
  gmp,
  libiconv,
  xz,
  readline,
  zlib,
  python3,
  ncurses,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

let
  # omit python (2.7), no need to introduce a
  # dependency on an EOL package for no reason
  libsFor = {
    iconv = [ libiconv ];
    gmp = [ gmp ];
    lzma = [ xz ];
    readline = [ readline ];
    python3 = [
      python3
      ncurses
    ];
    syslog = [ ];
    zlib = [ zlib ];
    cpp = [ ];
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "gnatcoll-${component}";
  version = "26.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "gnatcoll-bindings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7XC/oA2/Z4ytmN3/36vUbYOKHQyinbM8AAINrgitJYY=";
  };

  nativeBuildInputs = [
    gprbuild
    gnat
    python3
  ];

  # propagate since gprbuild needs to find referenced .gpr files
  # and all dependency C libraries when statically linking a
  # downstream executable.
  propagatedBuildInputs = [
    gnatcoll-core
  ]
  ++ libsFor."${component}" or [ ];

  makeFlags = [
    "--prefix"
    (placeholder "out")
  ]
  ++ lib.optionals (!enableShared) [
    "--library-types"
    "static"
  ];

  buildFlags = [
    "--target"
    stdenv.hostPlatform.config
  ]
  ++ lib.optionals (component == "readline") [
    # explicit flag for GPL acceptance because upstream
    # allows a gcc runtime exception for all bindings
    # except for readline (since it is GPL w/o exceptions)
    "--accept-gpl"
  ];

  buildPhase = ''
    runHook preBuild
    ${python3.interpreter} ${component}/setup.py build $makeFlags --jobs $NIX_BUILD_CORES $buildFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${python3.interpreter} ${component}/setup.py install $makeFlags
    runHook postInstall
  '';

  meta = {
    description = "GNAT Components Collection - Bindings to C libraries";
    homepage = "https://github.com/AdaCore/gnatcoll-bindings";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      sternenseemann
      sempiternal-aurora
    ];
  };
})
