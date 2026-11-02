{
  lib,
  stdenv,
  bzip2,
  curl,
  fetchFromGitHub,
  htslib,
  openssl,
  pcre2,
  xz,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vt";
  version = "unstable-${lib.substring 0 7 finalAttrs.src.rev}";

  src = fetchFromGitHub {
    owner = "atks";
    repo = "vt";
    rev = "c6bd1591a23a1d116d52834a627c00bbf7ed4a64";
    hash = "sha256-VcV0CZbniDgHfV12ExOqd0v9Ha+6ErwkLl4CJD/uO+8=";
  };

  strictDeps = true;

  buildInputs = [
    htslib
    pcre2
    openssl
    zlib
    bzip2
    xz
    curl
  ];

  dontConfigure = true;

  # The Makefile builds and links frozen 2021 snapshots of htslib, pcre2 and
  # libdeflate from lib/ - code that parses untrusted VCF/BCF/BAM input.
  # Upstream is dormant, so link the system shared libraries instead: swap
  # the .a variables for -lhts/-lpcre2-8 (libdeflate is pulled in by libhts
  # itself), drop the vendored include dirs and build prerequisites, and
  # define PCRE2_CODE_UNIT_WIDTH=8 as modern pcre2 headers require.
  # The link line also passes -lz/-lbz2/-llzma/-lcurl/-lcrypto directly, so
  # those libraries are explicit buildInputs instead of transitive ones.
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'INCLUDES = -I./lib -I. -I./lib/htslib -I./lib/Rmath -I./lib/pcre2' 'INCLUDES = -I./lib -I. -I./lib/Rmath' \
      --replace-fail 'LIBHTS = lib/htslib/libhts.a' 'LIBHTS = -lhts' \
      --replace-fail 'LIBPCRE2 = lib/pcre2/libpcre2.a' 'LIBPCRE2 = -lpcre2-8' \
      --replace-fail 'LIBDEFLATE = lib/libdeflate/libdeflate.a' 'LIBDEFLATE =' \
      --replace-fail 'CXXFLAGS = -pipe' 'CXXFLAGS = -DPCRE2_CODE_UNIT_WIDTH=8 -pipe' \
      --replace-fail '$(TARGET) : ''${LIBHTS} ''${LIBRMATH} ''${LIBPCRE2}  ''${LIBSVM} $(TOOLOBJ)' '$(TARGET) : ''${LIBRMATH} ''${LIBSVM} $(TOOLOBJ)'
  '';

  buildPhase = ''
    runHook preBuild
    make CXX=${stdenv.cc.targetPrefix}c++ -j$NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 vt $out/bin/vt
    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    description = "Tool set for short variant discovery in genetic sequence data";
    homepage = "https://github.com/atks/vt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mimame
      rollf
    ];
    mainProgram = "vt";
    platforms = lib.platforms.linux;
  };
})
