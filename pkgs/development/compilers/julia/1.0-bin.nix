{ autoPatchelfHook, fetchurl, lib, makeWrapper, openssl, stdenv }:

stdenv.mkDerivation rec {
  pname = "julia-bin";
  version = "1.0.5";

  src = {
    x86_64-linux = fetchurl {
      url = "https://julialang-s3.julialang.org/bin/linux/x64/${lib.versions.majorMinor version}/julia-${version}-linux-x86_64.tar.gz";
      sha256 = "00vbszpjmz47nqy19v83xa463ajhzwanjyg5mvcfp9kvfw9xdvcx";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  # Julia’s source files are in different locations for source and binary
  # releases. Thus we temporarily create symlinks to allow us to share patches
  # with source releases.
  prePatch = ''
    ln -s share/julia/stdlib/v${lib.versions.majorMinor version} stdlib
    ln -s share/julia/test
  '';
  patches = [
    # Source release Nix patch(es) relevant for binary releases as well.
    ./patches/1.0-bin/0002-nix-Skip-tests-that-require-network-access.patch
  ];
  postPatch = ''
    # Revert symlink hack.
    rm stdlib test
  '';

  buildInputs = [ makeWrapper ];
  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    cp -r . $out
    # Setting `LD_LIBRARY_PATH` resolves `Libdl` failures. Not sure why this is
    # only necessary on v1.0.x and a cleaner solution is welcome, but after
    # staring at `strace` for a few hours this is as clean as I could make it.
    wrapProgram $out/bin/julia \
      --suffix LD_LIBRARY_PATH : $out/lib
    runHook postInstall
  '';

  # Breaks backtraces, etc.
  dontStrip = true;

  doInstallCheck = true;
  installCheckInputs = [ openssl ];
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
    description = "High-level, high-performance dynamic language for technical computing";
    homepage = "https://julialang.org";
    # Bundled and linked with various GPL code, although Julia itself is MIT.
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ninjin raskin ];
    platforms = [ "x86_64-linux" ];
    knownVulnerabilities = [
      # Built with libgit2 v0.27.2:
      #   https://github.com/JuliaLang/julia/blob/e0837d1e64a9e4d17534a9f981e9a2a3f221356f/deps/libgit2.version
      # https://nvd.nist.gov/vuln/detail/CVE-2020-12278
      "CVE-2020-12278"
      # https://nvd.nist.gov/vuln/detail/CVE-2020-12279
      "CVE-2020-12279"
    ];
  };
}
