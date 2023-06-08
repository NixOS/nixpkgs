{ autoPatchelfHook, fetchurl, lib, stdenv }:

let
  skip_tests = [
    # Test flaky on ofborg
    "channels"

    # Test flaky because of our RPATH patching
    # https://github.com/NixOS/nixpkgs/pull/230965#issuecomment-1545336489
    "compiler/codegen"
  ] ++ lib.optionals stdenv.isDarwin [
    # Test flaky on ofborg
    "FileWatching"
    # Test requires pbcopy
    "InteractiveUtils"
    # Test requires network access
    "Sockets"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    # Test Failed at $out/share/julia/stdlib/v1.8/LinearAlgebra/test/blas.jl:702
    "LinearAlgebra/blas"
    # Test Failed at $out/share/julia/test/misc.jl:724
    "misc"
  ];
in
stdenv.mkDerivation rec {
  pname = "julia-bin";
  version = "1.9.1";

  src = {
    x86_64-linux = fetchurl {
      url = "https://julialang-s3.julialang.org/bin/linux/x64/${lib.versions.majorMinor version}/julia-${version}-linux-x86_64.tar.gz";
      hash = "sha256-zeFKWPiZJR8wz87YcFVib0SEV4Blnr6NUMvExnsxmXw=";
    };
    aarch64-linux = fetchurl {
      url = "https://julialang-s3.julialang.org/bin/linux/aarch64/${lib.versions.majorMinor version}/julia-${version}-linux-aarch64.tar.gz";
      hash = "sha256-tkPM0+Kllg985wVSQ3Q9Cjm63aOXS849d4Yd02O63RA=";
    };
    x86_64-darwin = fetchurl {
      url = "https://julialang-s3.julialang.org/bin/mac/x64/${lib.versions.majorMinor version}/julia-${version}-mac64.tar.gz";
      hash = "sha256-STaN2u9ON+1gaAimyli6DxpEUaJ7ggGu1NnXskwnaBc=";
    };
    aarch64-darwin = fetchurl {
      url = "https://julialang-s3.julialang.org/bin/mac/aarch64/${lib.versions.majorMinor version}/julia-${version}-macaarch64.tar.gz";
      hash = "sha256-nj4CymVGUT3OJlN5q+lXyytbDM9AZiGUhtoOuHLdzrw=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  patches = [
    # https://github.com/JuliaLang/julia/commit/f5eeba35d9bf20de251bb9160cc935c71e8b19ba
    ./patches/1.9-bin/0001-allow-skipping-internet-required-tests.patch
  ];

  postPatch = ''
    # Julia fails to pick up our Certification Authority root certificates, but
    # it provides its own so we can simply disable the test. Patching in the
    # dynamic path to ours require us to rebuild the Julia system image.
    substituteInPlace share/julia/stdlib/v${lib.versions.majorMinor version}/NetworkOptions/test/runtests.jl \
      --replace '@test ca_roots_path() != bundled_ca_roots()' \
        '@test_skip ca_roots_path() != bundled_ca_roots()'
  '';

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
    # https://github.com/JuliaLang/julia/blob/v1.9.0/NEWS.md#external-dependencies
    stdenv.cc.cc
  ];

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  # Breaks backtraces, etc.
  dontStrip = true;

  doInstallCheck = true;
  preInstallCheck = ''
    export JULIA_TEST_USE_MULTIPLE_WORKERS=true
    # Some tests require read/write access to $HOME.
    export HOME="$TMPDIR"
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
    maintainers = with lib.maintainers; [ raskin nickcao wegank ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "julia";
  };
}
