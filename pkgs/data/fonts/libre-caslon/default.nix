{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libre-caslon-${version}";
  version = "1.002";

  srcs = [
    (fetchFromGitHub {
      owner = "impallari";
      repo = "Libre-Caslon-Text";
      rev = "c31e21f7e8cf91f18d90f778ce20e66c68219c74";
      name = "libre-caslon-text-${version}-src";
      sha256 = "0zczv9qm8cgc7w1p64mnf0p0fi7xv89zhf1zzf1qcna15kbgc705";
    })

    (fetchFromGitHub {
      owner = "impallari";
      repo = "Libre-Caslon-Display";
      rev = "3491f6a9cfde2bc15e736463b0bc7d93054d5da1";
      name = "libre-caslon-display-${version}-src";
      sha256 = "12jrny3y8w8z61lyw470drnhliji5b24lgxap4w3brp6z3xjph95";
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}
    cp -v "libre-caslon-text-${version}-src/fonts/OTF/"*.otf $out/share/fonts/opentype/
    cp -v "libre-caslon-display-${version}-src/fonts/OTF/"*.otf $out/share/fonts/opentype/
    cp -v libre-caslon-text-${version}-src/README.md libre-caslon-text-${version}-src/FONTLOG.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    description = "Caslon fonts based on hand-lettered American Caslons of 1960s";
    homepage = http://www.impallari.com/librecaslon;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
