{ lib, mkFont, fetchurl, dpkg }:

mkFont rec {
  pname = "kochi-substitute";
  version = "20030809";

  src = fetchurl {
    url = "mirror://debian/pool/main/t/ttf-kochi/ttf-kochi-gothic_${version}-15_all.deb";
    sha256 = "6e2311cd8e880a9328e4d3eef34a1c1f024fc87fba0dce177a0e1584a7360fea";
  };

  src2 = fetchurl {
    url = "mirror://debian/pool/main/t/ttf-kochi/ttf-kochi-mincho_${version}-15_all.deb";
    sha256 = "91ce6c993a3a0f77ed85db76f62ce18632b4c0cbd8f864676359a17ae5e6fa3c";
  };

  nativeBuildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb --fsys-tarfile $src | tar xf - ./usr/share/fonts/truetype/kochi/kochi-gothic-subst.ttf
    dpkg-deb --fsys-tarfile $src2 | tar xf - ./usr/share/fonts/truetype/kochi/kochi-mincho-subst.ttf
  '';

  meta = with lib; {
    description = "Japanese font, a free replacement for MS Gothic and MS Mincho";
    longDescription = ''
      Kochi Gothic and Kochi Mincho were developed as free replacements for the
      MS Gothic and MS Mincho fonts from Microsoft. These are the Debian
      versions of the fonts, which remove some non-free glyphs that were added
      from the naga10 font.
    '';
    homepage = "https://osdn.net/projects/efont/";
    license = licenses.wadalab;
    maintainers = with maintainers; [ maintainers.auntie ];
  };
}
