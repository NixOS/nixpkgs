{ autoPatchelfHook, fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "julia-bin";
  version = "1.7.3";

  src = {
    x86_64-linux = fetchurl {
      url = "https://julialang-s3.julialang.org/bin/linux/x64/${lib.versions.majorMinor version}/julia-${version}-linux-x86_64.tar.gz";
      sha256 = "0ff7ypr76xf99h3dmy1xdnkq2xn432qnzihxs72xrd4j5nhlybwv";
    };
    # Julia uses Rosetta on aarch64-darwin
    aarch64-darwin = fetchurl {
      url = "https://julialang-s3.julialang.org/bin/mac/x64/${lib.versions.majorMinor version}/julia-${version}-mac64.tar.gz";
      sha256 = "sha256-A2g9tDfNe1TMlfogccUgXwwd/jmt7N4Q4b3rtNJBZJM=";
    };
    x86_64-darwin = fetchurl {
      url = "https://julialang-s3.julialang.org/bin/mac/x64/${lib.versions.majorMinor version}/julia-${version}-mac64.tar.gz";
      sha256 = "sha256-A2g9tDfNe1TMlfogccUgXwwd/jmt7N4Q4b3rtNJBZJM=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  # Julia’s source files are in different locations for source and binary
  # releases. Thus we temporarily create a symlink to allow us to share patches
  # with source releases.
  prePatch = ''
    ln -s share/julia/test
  '';
  patches = [
    # Source release Nix patch(es) relevant for binary releases as well.
    ./patches/1.7-bin/0005-nix-Enable-parallel-unit-tests-for-sandbox.patch
    ./patches/1.7-bin/0005-nix-Disable-https-tests.patch
  ];
  postPatch = ''
    # Revert symlink hack.
    rm test

    # Julia fails to pick up our Certification Authority root certificates, but
    # it provides its own so we can simply disable the test. Patching in the
    # dynamic path to ours require us to rebuild the Julia system image.
    substituteInPlace share/julia/stdlib/v${lib.versions.majorMinor version}/NetworkOptions/test/runtests.jl \
      --replace '@test ca_roots_path() != bundled_ca_roots()' \
        '@test_skip ca_roots_path() != bundled_ca_roots()'
  '';

  # Note that fixDarwinDylibNames fails for Darwin because install_name_tool claims "string table not at end" of one
  # of the dylibs.
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
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
      $out/share/julia/test/runtests.jl
    runHook postInstallCheck
  '';

  meta = {
    description = "High-level, high-performance, dynamic language for technical computing";
    homepage = "https://julialang.org";
    # Bundled and linked with various GPL code, although Julia itself is MIT.
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ninjin raskin ];
    platforms = [ "x86_64-linux" "aarch64-darwin" ];
  };
}
