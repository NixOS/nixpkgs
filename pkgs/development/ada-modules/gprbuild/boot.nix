{
  stdenv,
  lib,
  applyPatches,
  fetchFromGitHub,
  fetchpatch2,
  gnat,
  which,
  xmlada, # for src
}:

let
  version = "25.0.0";

  gprconfig_kb = applyPatches {
    src = fetchFromGitHub {
      owner = "AdaCore";
      repo = "gprconfig_kb";
      tag = "v${version}";
      hash = "sha256-Oax3Aq+XHiMd823jtVUy43j4Sk7jVfD4cueDCLC0oSc=";
    };

    patches = [
      ./gprconfig_kb-darwin.patch
    ];

    postPatch = ''
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

      install -m644 ${./nixpkgs-gnat.xml} db/nixpkgs-gnat.xml
    '';
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
    hash = "sha256-XEluJGBEWAixHg3NeL78sJqv9pooaDqEQO+vggGrGtc=";
  };

  nativeBuildInputs = [
    gnat
    which
  ];

  # Fix compilation with GNAT 16
  patches = lib.optionals (lib.versionAtLeast gnat.version "16") [
    # gpr-compilation-process.adb:44:29: error: operator for type "String" is not declared in "Env_Maps"
    (fetchpatch2 {
      url = "https://github.com/AdaCore/gprbuild/commit/6421e350274b3018a26bd058b1c90d033b053f71.patch?full_index=1";
      hash = "sha256-u9bmr8abmthlyHoeqW5nS2CnaxXmbx6WVwhemxVtw+0=";
    })
    # gpr-compilation-protocol.adb:981:13: error: "time_t" is undefined
    (fetchpatch2 {
      url = "https://github.com/AdaCore/gprbuild/commit/6b6be939d69d534beb7faca17664d7a1ffa9c81e.patch?full_index=1";
      hash = "sha256-YUjBvA4bBsrCB46o5WVHOZR6qOf2bkMg+A9qlystDbc=";
    })
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
      --with-kb=${gprconfig_kb} \
      --prefix=$out

    runHook postInstall
  '';

  meta = {
    description = "Multi-language extensible build tool";
    homepage = "https://github.com/AdaCore/gprbuild";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = lib.platforms.all;
  };
}
