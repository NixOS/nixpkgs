{
  stdenv,
  lib,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "ttaenc";
  version = "3.4.1";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/tta/${finalAttrs.name}-${finalAttrs.version}-src.tgz";
    sha256 = "sha256-ssnIsBWsxYZPCCoBV/LgnFEX0URTIctheOkltEi+PcY=";
  };

  patches = [
    ./makefile.patch # Use stdenv's CC
    ./ttaenc-inline.patch # Patch __inline used into always_inline for both GCC and clang
  ];

  makeFlags = [ "INSDIR=$(out)/bin" ];

  preBuild = ''
    # From the Makefile, with `-msse` removed, since we have those on by x86_64 by default.
    makeFlagsArray+=(CFLAGS="-Wall -O3 -fomit-frame-pointer -funroll-loops -fforce-addr -falign-functions=4")
  '';

  postInstall = ''
    # Copy docs
    install -dm755 "$out/share/doc/${finalAttrs.name}"
    install -m644 "ChangeLog-${finalAttrs.version}" README "$out/share/doc/${finalAttrs.name}"
  '';

  meta = with lib; {
    description = "Lossless compressor for multichannel 8, 16 and 24 bits audio data, with the ability of password data protection";
    homepage = "https://sourceforge.net/projects/tta/";
    license = with licenses; [
      gpl3Only
      lgpl3Only
    ];
    platforms = platforms.all;
    mainProgram = "ttaenc";
    maintainers = with maintainers; [ natsukagami ];
  };
})
