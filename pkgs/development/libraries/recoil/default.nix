{ stdenv, fetchgit
, libpng
, cito, libxslt
, magickSupport ? true, imagemagick
, perl, XMLDOM }:

let inherit (stdenv) lib; in

stdenv.mkDerivation rec {
  name = "recoil-${version}";
  version = "4.3.1";

  src = fetchgit {
    url = "https://git.code.sf.net/p/recoil/code";
    rev = "recoil-${version}";
    name = "recoil";
    sha256 = "1xnz256dzvm05s0hhqc5s2rkgvsk5dgnjd8ddw5fw1j3v63ssl23";
  };

  outputs = [ "bin" "man" "dev" "out" ];

  nativeBuildInputs = [
    cito libxslt.bin
  ] ++ (lib.optionals magickSupport [
    perl XMLDOM
  ]);
  buildInputs = [ libpng ] ++ (lib.optional magickSupport imagemagick);

  postPatch = lib.optionalString magickSupport ''
    substituteInPlace Makefile \
      --replace \
        '$(wildcard $(MAGICK_PREFIX)/lib/ImageMagick-$(word 1,$(MAGICK_VERSION))/modules-$(word 2,$(MAGICK_VERSION))/coders)' \
        '$(out)/lib/ImageMagick-$(word 1,$(MAGICK_VERSION))/modules-$(word 2,$(MAGICK_VERSION))/coders' \
      --replace ') imagemagick/recoilmagick.c' ') -I. imagemagick/recoilmagick.c'
    cp -r --no-preserve mode,ownership ${imagemagick.src} imagemagick_src
    cp -r --no-preserve mode,ownership ${imagemagick}/etc/ImageMagick-* fake_magick_config
  '';

  makeFlags = [
    "PREFIX=$(out)" "BUILDING_PACKAGE=yes"
  ] ++ (lib.optionals magickSupport [
    "MAGICK_INCLUDE_PATH=imagemagick_src"
    "MAGICK_CONFIG_PATH=fake_magick_config"
  ]);

  preFixup = ''
    mkdir -p $bin/bin
    mv -t $bin/bin $out/bin/*
    rmdir $out/bin

    mkdir -p $man/share
    mv -t $man/share $out/share/man
    mkdir -p $bin/share
    mv -t $bin/share $out/share/{mime,thumbnailers}
    rmdir $out/share

    mkdir -p $out/share/doc/recoil
    cp fake_magick_config/coder.xml $out/share/doc/recoil/imagemagick-coder.xml

    mkdir -p $bin/lib
    mv -t $bin/lib $out/lib/ImageMagick-*
    rmdir $out/lib

    mkdir -p $dev/{include,src}
    cp -t $dev/include recoil.h
    cp -t $dev/src recoil.c
  '';

  meta = with lib; {
    description = "Retro Computer Image Library";
    longDescription = ''
      Retro Computer Image Library decodes Amiga, Amstrad CPC, Apple II, Atari
      8-bit, Atari Portfolio, Atari ST/TT/Falcon, BBC Micro, Commodore 16,
      Commodore 64, Commodore 128, Macintosh 128K, MSX, NEC PC-88, NEC PC-98,
      Oric, SAM Coupe, Sharp X68000, Timex 2048, TRS-80, TRS-80 Color Computer,
      ZX81 and ZX Spectrum picture formats. The project contains a simple
      viewer, plug-ins for general-purpose image viewers and editors, and an
      everything-to-png converter.
    '';
    homepage = http://recoil.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ bb010g ];
  };
}
