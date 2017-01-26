{ stdenv, fetchFromGitHub, unzip }:

stdenv.mkDerivation rec {
  name = "overpass-${version}";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "RedHatBrand";
    repo = "Overpass";
    rev = version;
    sha256 = "1bgmnhdfmp4rycyadcnzw62vkvn63nn29pq9vbjf4c9picvl8ah6";
  };

  nativeBuildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/doc/${name}
    mkdir -p $out/share/fonts/opentype
    cp -v "desktop-fonts/"*"/"*.otf $out/share/fonts/opentype
    cp -v LICENSE.md README.md $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = http://overpassfont.org/;
    description = "Font heavily inspired by Highway Gothic";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
