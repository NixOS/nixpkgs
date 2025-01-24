{
  lib,
  stdenv,
  fetchFromGitHub,
  applyPatches,
  autoreconfHook,
  nix-update-script,

  # Required dependencies.
  openssl,
  zlib,
  libxml2,

  # Optional dependencies.
  e2fsprogs,
  bzip2,
  xz, # lzma

  # Platform-specific dependencies.
  acl,
  musl-fts,

  # for tests
  testers,
  python3,
  libxslt, # xsltproc
  runCommand,
  runCommandCC,
  makeWrapper,
  xar,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xar${lib.optionalString (e2fsprogs == null) "-minimal"}";
  version = "501";

  src = fetchFromGitHub {
    owner = "apple-oss-distributions";
    repo = "xar";
    rev = "xar-${finalAttrs.version}";
    hash = "sha256-Fq+Re0LCBIGhW2FR+pgV8SWtaDOEFgTh+rQ8JFWK/k0=";
  };

  # Update patch set with
  #   git clone https://github.com/apple-oss-distributions/xar
  #   cd xar
  #   git switch -c nixpkgs
  #   git am ../pkgs/by-name/xa/xar/patches/*
  #   # …
  #   rm -r ../pkgs/by-name/xa/xar/patches
  #   git format-patch --zero-commit --output-directory ../pkgs/by-name/xa/xar/patches main
  patches =
    # Avoid Darwin rebuilds on staging-next
    lib.filter (
      p: stdenv.hostPlatform.isDarwin -> baseNameOf p != "0020-Fall-back-to-readlink-on-Linux.patch"
    ) (lib.filesystem.listFilesRecursive ./patches);

  # We do not use or modify files outside of the xar subdirectory.
  patchFlags = [ "-p2" ];
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
      # NB we use OpenSSL instead of CommonCrypto on Darwin.
      openssl
      zlib
      libxml2
      bzip2
      xz
      e2fsprogs
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux acl
    ++ lib.optional stdenv.hostPlatform.isMusl musl-fts;

  passthru =
    let
      patchedSource = applyPatches { inherit (finalAttrs) src patches; };
      pythonForTests = python3.withPackages (p: [ p.xattr ]);
    in
    {
      # Tests xar outside of the Nix sandbox (extended attributes are not supported
      # in Nix sandbox, e.g. filtered with seccomp on Linux).
      #
      # Run with
      # $ nix run --file . xar.impureTests.integrationTest
      # Ensure that all tests are PASSED and none are FAILED or SKIPPED.
      impureTests.integrationTest =
        runCommand "xar-impure-tests-integration-test"
          {
            src = patchedSource;
            xar = finalAttrs.finalPackage;
            xsltproc = lib.getBin libxslt;
            pythonInterpreter = pythonForTests.interpreter;
            nativeBuildInputs = [ makeWrapper ];
          }
          ''
            makeWrapper "$pythonInterpreter" "$out/bin/$name" \
              --prefix PATH : "$xar/bin" \
              --suffix PATH : "$xsltproc/bin" \
              --add-flags -- \
              --add-flags "$src/xar/test/run-all.py"
          '';

      tests = lib.optionalAttrs (stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
        version = testers.testVersion {
          package = finalAttrs.finalPackage;
          version = "1.8dev";
        };

        integrationTest =
          runCommand "xar-tests-integration-test"
            {
              src = patchedSource;
              strictDeps = true;
              pythonExecutable = pythonForTests.executable;
              nativeBuildInputs = [
                finalAttrs.finalPackage
                pythonForTests
                libxslt
              ];
            }
            ''
              "$pythonExecutable" "$src"/xar/test/run-all.py
              touch "$out"
            '';

        smokeTest =
          runCommandCC "xar-tests-smoke-test"
            {
              src = patchedSource;
              strictDeps = true;
              nativeBuildInputs = [ finalAttrs.finalPackage ];
              buildInputs = [
                finalAttrs.finalPackage
                openssl
              ];
            }
            ''
              cp "$src"/xar/test/{buffer.c,validate.c} .
              "$CC" -lxar -o buffer buffer.c
              "$CC" -lxar -lcrypto -o validate validate.c
              ./buffer validate.c
              xar -x -f test.xar
              diff validate.c mydir/secondfile
              ./validate test.xar
              touch "$out"
            '';
      };

      updateScript = nix-update-script {
        extraArgs = [
          "--version-regex"
          "xar-(.*)"
        ];
      };
    };

  meta = {
    homepage = "https://github.com/apple-oss-distributions/xar";
    description = "An easily extensible archive format";
    license = lib.licenses.bsd3;
    maintainers =
      lib.teams.darwin.members
      ++ lib.attrValues { inherit (lib.maintainers) copumpkin tie; };
    platforms = lib.platforms.unix;
    mainProgram = "xar";
  };
})
