{ autoPatchelfHook, fetchurl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "julia-bin";
  version = "1.6.6";

  src = {
    x86_64-linux = fetchurl {
      url = "https://julialang-s3.julialang.org/bin/linux/x64/${lib.versions.majorMinor version}/julia-${version}-linux-x86_64.tar.gz";
      sha256 = "0ia9a4h7w0n5rg57fkl1kzcyj500ymfwq3qsd2r7l82288dgfpy2";
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
    ./patches/1.6-bin/0005-nix-Enable-parallel-unit-tests-for-sandbox.patch
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

  nativeBuildInputs = [ autoPatchelfHook ];

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
    platforms = [ "x86_64-linux" ];
    mainProgram = "julia";
  };
}
