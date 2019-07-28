{ stdenv, fetchFromGitHub, cairo, pngquant, zopfli
, which, pythonPackages, pkgconfig, imagemagick }: stdenv.mkDerivation rec {
  pname = "blobmoji";
  version = "2019-06-14-Emoji-12";

  src = fetchFromGitHub {
    owner = "C1710";
    repo = pname;
    rev = "v${version}";
    sha256 = "19xwjarpn40jyibp7d2g0ss2c9hifrskkig234wdng08gc1p4z84";
  };

  buildInputs = [ cairo ];
  nativeBuildInputs = [ cairo pngquant zopfli which pkgconfig imagemagick ]
                      ++ (with pythonPackages; [ python fonttools nototools ]);
  enableParallelBuilding = true;

  postPatch = ''
    sed -i 's,^PNGQUANT :=.*,PNGQUANT := ${pngquant}/bin/pngquant,' Makefile
    patchShebangs flag_glyph_name.py
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/noto
    cp NotoColorEmoji.ttf fonts/Blobmoji.ttf $out/share/fonts/noto
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "Noto Emoji with extended Blob support";
    homepage = "https://github.com/C1710/blobmoji";
    license = with licenses; [ ofl asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ das_j ];
  };
}
