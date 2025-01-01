{
  stdenv,
  lib,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ttaenc";
  version = "3.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/tta/ttaenc-${finalAttrs.version}-src.tgz";
    sha256 = "sha256-ssnIsBWsxYZPCCoBV/LgnFEX0URTIctheOkltEi+PcY=";
  };

  patches = [
    ./makefile.patch # Use stdenv's CC
    ./ttaenc-inline.patch # Patch __inline used into always_inline for both GCC and clang
  ];

  makeFlags = [ "INSDIR=$(out)/bin" ];

  preBuild = ''
    # From the Makefile, with `-msse` removed, since we have those on by x86_64 by default.
    makeFlagsArray+=(CFLAGS="-Wall -O2 -fomit-frame-pointer -funroll-loops -fforce-addr -falign-functions=4")
  '';

  postInstall = ''
    # Copy docs
    install -dm755 "$out/share/doc/${finalAttrs.pname}"
    install -m644 "ChangeLog-${finalAttrs.version}" README "$out/share/doc/${finalAttrs.pname}"
  '';

  meta = {
    description = "Lossless compressor for multichannel 8, 16 and 24 bits audio data, with the ability of password data protection";
    homepage = "https://sourceforge.net/projects/tta/";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
    ];
    platforms = lib.platforms.unix;
    mainProgram = "ttaenc";
    maintainers = with lib.maintainers; [ natsukagami ];
  };
})
