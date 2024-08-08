{
  lib,
  stdenv,
  fetchurl,
  applyPatches,

  autoreconfHook,

  # Required dependencies.
  zlib,
  libxml2,

  # Optional dependencies.
  withExt2 ? lib.meta.availableOn stdenv.hostPlatform e2fsprogs,
  e2fsprogs,
  withAcl ? lib.meta.availableOn stdenv.hostPlatform acl,
  acl,
  withBzip2 ? true,
  bzip2,
  withLzma ? true,
  xz, # lzma

  # Platform-specific dependencies.
  musl-fts,
  openssl,
  darwin, # CommonCrypto

  gitUpdater,

  # for tests
  xar,
  testers,
  python3,
  libxslt, # xsltproc
  runCommand,
  makeWrapper,
  buildPackages,
}:
let
  pname = "xar";
  version = "498";

  pythonForTests = py: py.withPackages (p: [ p.xattr ]);

  src = applyPatches {
    name = "source";
    src = fetchurl {
      url = "https://opensource.apple.com/tarballs/xar/xar-${version}.tar.gz";
      hash = "sha256-nO5PgLls9ZLMxUWk/dUeTaSlvTtHNJAWN9Z7BD7/PHU=";
    };
    patches = lib.filesystem.listFilesRecursive ./patches;
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  sourceRoot = "source/xar";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  # For some reason libxml2 package headers are in subdirectory and thus aren’t
  # picked up by stdenv’s C compiler wrapper (see ccWrapper_addCVars). This
  # doesn’t really belong here and either should be part of libxml2 package or
  # libxml2 in Nixpkgs can just fix their header paths.
  env.NIX_CFLAGS_COMPILE = "-isystem ${libxml2.dev}/include/libxml2";

  buildInputs =
    [
      zlib
      libxml2
    ]
    # Darwin uses CommonCrypto, other platforms use openssl.
    ++ lib.optional stdenv.hostPlatform.isDarwin darwin.CommonCrypto
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) openssl
    ++ lib.optional withExt2 e2fsprogs
    ++ lib.optional withAcl acl
    ++ lib.optional withBzip2 bzip2
    ++ lib.optional withLzma xz
    ++ lib.optional stdenv.hostPlatform.isMusl musl-fts;

  passthru.tests = {
    version = testers.testVersion {
      package = xar;
      version = "1.8dev";
    };

    # Check that xar builds without optional dependencies.
    minimal = xar.override {
      withExt2 = false;
      withAcl = false;
      withBzip2 = false;
      withLzma = false;
    };

    integrationTest =
      let
        python = pythonForTests python3.pythonOnBuildForHost;
      in
      runCommand "xar-tests-integration-test"
        {
          inherit src;
          python = python.executable;
          nativeBuildInputs = [
            xar
            python
            libxslt
          ];
        }
        ''
          "$python" -- "$src"/xar/test/run-all.py
          touch -- "$out"
        '';

    smokeTest =
      runCommand "xar-tests-smoke-test"
        {
          inherit src;
          depsBuildBuild = [
            buildPackages.stdenv.cc
            xar
            openssl
          ];
        }
        ''
          cp -- "$src"/xar/test/{buffer.c,validate.c} .
          "$CC_FOR_BUILD" -lxar -o buffer buffer.c
          "$CC_FOR_BUILD" -lxar -lcrypto -o validate validate.c
          ./buffer validate.c
          xar -x -f test.xar
          diff validate.c mydir/secondfile
          ./validate test.xar
          touch -- "$out"
        '';

    # For convenience, we expose manualTest to allow testing xar manually (since
    # extended attributes are not supported in Nix sandbox).
    #
    # Run with
    # $ manualTest=$(nix build --no-link --print-out-paths --file . xar.tests.manualTest) && "$manualTest"
    # Ensure that all tests are PASSED and none are FAILED or SKIPPED.
    manualTest =
      runCommand "xar-manual-test"
        {
          inherit src xar libxslt;
          python = (pythonForTests python3).interpreter;
          nativeBuildInputs = [ makeWrapper ];
        }
        ''
          makeWrapper "$python" "$out" \
            --prefix PATH : "$xar/bin" \
            --suffix PATH : "$libxslt/bin" \
            --add-flags -- \
            --add-flags "$src/xar/test/run-all.py"
        '';
  };

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/apple-oss-distributions/xar";
    description = "An easily extensible archive format";
    license = lib.licenses.bsd3;
    maintainers = lib.attrValues { inherit (lib.maintainers) copumpkin tie; };
    platforms = lib.platforms.unix;
    mainProgram = "xar";
  };
}
