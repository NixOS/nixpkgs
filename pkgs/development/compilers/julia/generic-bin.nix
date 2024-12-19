{
  version,
  sha256,
  patches ? [ ],
}:

{
  autoPatchelfHook,
  fetchurl,
  lib,
  stdenv,
}:

let
  skip_tests =
    [
      # Test flaky on ofborg
      "channels"
      # Test flaky because of our RPATH patching
      # https://github.com/NixOS/nixpkgs/pull/230965#issuecomment-1545336489
      "compiler/codegen"
      # Test flaky
      "read"
    ]
    ++ lib.optionals (lib.versionAtLeast version "1.10") [
      # Test flaky
      # https://github.com/JuliaLang/julia/issues/52739
      "REPL"
      # Test flaky
      "ccall"
    ]
    ++ lib.optionals (lib.versionAtLeast version "1.11") [
      # Test flaky
      # https://github.com/JuliaLang/julia/issues/54280
      "loading"
      "cmdlineargs"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Test flaky on ofborg
      "FileWatching"
      # Test requires pbcopy
      "InteractiveUtils"
      # Test requires network access
      "Sockets"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      # Test Failed at $out/share/julia/stdlib/v1.8/LinearAlgebra/test/blas.jl:702
      "LinearAlgebra/blas"
      # Test Failed at $out/share/julia/test/misc.jl:724
      "misc"
    ];
in
stdenv.mkDerivation {
  pname = "julia-bin";

  inherit version patches;

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://julialang-s3.julialang.org/bin/linux/x64/${lib.versions.majorMinor version}/julia-${version}-linux-x86_64.tar.gz";
        sha256 = sha256.x86_64-linux;
      };
      aarch64-linux = fetchurl {
        url = "https://julialang-s3.julialang.org/bin/linux/aarch64/${lib.versions.majorMinor version}/julia-${version}-linux-aarch64.tar.gz";
        sha256 = sha256.aarch64-linux;
      };
      x86_64-darwin = fetchurl {
        url = "https://julialang-s3.julialang.org/bin/mac/x64/${lib.versions.majorMinor version}/julia-${version}-mac64.tar.gz";
        sha256 = sha256.x86_64-darwin;
      };
      aarch64-darwin = fetchurl {
        url = "https://julialang-s3.julialang.org/bin/mac/aarch64/${lib.versions.majorMinor version}/julia-${version}-macaarch64.tar.gz";
        sha256 = sha256.aarch64-darwin;
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  postPatch = ''
    # Julia fails to pick up our Certification Authority root certificates, but
    # it provides its own so we can simply disable the test. Patching in the
    # dynamic path to ours require us to rebuild the Julia system image.
    substituteInPlace share/julia/stdlib/v${lib.versions.majorMinor version}/NetworkOptions/test/runtests.jl \
      --replace '@test ca_roots_path() != bundled_ca_roots()' \
        '@test_skip ca_roots_path() != bundled_ca_roots()'
  '';

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    # https://github.com/JuliaLang/julia/blob/v1.9.0/NEWS.md#external-dependencies
    stdenv.cc.cc
  ];

  installPhase =
    ''
      runHook preInstall
      cp -r . $out
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      # "$out/share" is intentionally omitted since it contains
      # julia package images and patchelf would break them
      autoPatchelf "$out/bin" "$out/lib" "$out/libexec"
    ''
    + ''
      runHook postInstall
    '';

  # Breaks backtraces, etc.
  dontStrip = true;
  dontAutoPatchelf = true;

  doInstallCheck = true;

  preInstallCheck = ''
    export JULIA_TEST_USE_MULTIPLE_WORKERS=true
    # Some tests require read/write access to $HOME.
    # And $HOME cannot be equal to $TMPDIR as it causes test failures
    export HOME=$(mktemp -d)
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    # Command lifted from `test/Makefile`.
    $out/bin/julia \
      --check-bounds=yes \
      --startup-file=no \
      --depwarn=error \
      $out/share/julia/test/runtests.jl \
      --skip internet_required ${toString skip_tests}
    runHook postInstallCheck
  '';

  meta = {
    description = "High-level, high-performance, dynamic language for technical computing";
    homepage = "https://julialang.org";
    # Bundled and linked with various GPL code, although Julia itself is MIT.
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      raskin
      nickcao
      wegank
      thomasjm
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "julia";
  };
}
