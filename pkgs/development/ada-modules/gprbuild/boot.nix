{
  stdenv,
  lib,
  fetchFromGitHub,
  gnat,
  which,
  xmlada, # for src
}:

let
  version = "25.0.0";

  gprConfigKbSrc = fetchFromGitHub {
    name = "gprconfig-kb-${version}-src";
    owner = "AdaCore";
    repo = "gprconfig_kb";
    rev = "v${version}";
    sha256 = "09x1njq0i0z7fbwg0mg39r5ghy7369avbqvdycfj67lpmw17gb1r";
  };
in

stdenv.mkDerivation {
  pname = "gprbuild-boot";
  inherit version;

  src = fetchFromGitHub {
    name = "gprbuild-${version}";
    owner = "AdaCore";
    repo = "gprbuild";
    rev = "v${version}";
    sha256 = "1mqsmc0q5bzg8223ls18kbvaz6mhzjz7ik8d3sqhhn24c0j6wjaw";
  };

  nativeBuildInputs = [
    gnat
    which
  ];

  postPatch = ''
    # The Makefile uses gprbuild to build gprbuild which
    # we can't do at this point, delete it to prevent the
    # default phases from failing.
    rm Makefile

    # make sure bootstrap script runs
    patchShebangs --build bootstrap.sh
  '';

  # This setupHook populates GPR_PROJECT_PATH which is used by
  # gprbuild to find dependencies. It works quite similar to
  # the pkg-config setupHook in the sense that it also splits
  # dependencies into GPR_PROJECT_PATH and GPR_PROJECT_PATH_FOR_BUILD,
  # but gprbuild itself doesn't support this, so we'll need to
  # introducing a wrapper for it in the future remains TODO.
  # For the moment this doesn't matter since we have no situation
  # were gprbuild is used to build something used at build time.
  setupHooks = [
    ./gpr-project-path-hook.sh
  ]
  ++ lib.optionals stdenv.targetPlatform.isDarwin [
    # This setupHook replaces the paths of shared libraries starting
    # with @rpath with the absolute paths on Darwin, so that the
    # binaries can be run without additional setup.
    ./gpr-project-darwin-rpath-hook.sh
  ];

  installPhase = ''
    runHook preInstall

    ./bootstrap.sh \
      --with-xmlada=${xmlada.src} \
      --with-kb=${gprConfigKbSrc} \
      --prefix=$out

    # Install custom compiler description which can detect nixpkgs'
    # GNAT wrapper as a proper Ada compiler. The default compiler
    # description expects the runtime library to be installed in
    # the same prefix which isn't the case for nixpkgs. As a
    # result, it would detect the unwrapped GNAT as a proper
    # compiler which is unable to produce working binaries.
    #
    # Our compiler description is very similar to the upstream
    # GNAT description except that we use a symlink in $out/nix-support
    # created by the cc-wrapper to find the associated runtime
    # libraries and use gnatmake instead of gnatls to find GNAT's
    # bin directory.
    install -m644 ${./nixpkgs-gnat.xml} $out/share/gprconfig/nixpkgs-gnat.xml

    runHook postInstall
  '';

  meta = with lib; {
    description = "Multi-language extensible build tool";
    homepage = "https://github.com/AdaCore/gprbuild";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.all;
  };
}
