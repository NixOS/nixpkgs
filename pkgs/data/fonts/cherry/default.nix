{ stdenv, fetchFromGitHub, bdftopcf }:

stdenv.mkDerivation rec {
  pname = "cherry";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "turquoise-hexagon";
    repo = pname;
    rev = version;
    sha256 = "1zaiqspf6y0hpszhihdsvsyw33d3ffdap4dym7w45wfrhdpvpi0p";
  };

  nativeBuildInputs = [ bdftopcf ];

  buildPhase = ''
    patchShebangs make.sh
    ./make.sh
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/misc
    cp *.pcf $out/share/fonts/misc
  '';

  meta = with stdenv.lib; {
    description = "cherry font";
    homepage = https://github.com/turquoise-hexagon/cherry;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

