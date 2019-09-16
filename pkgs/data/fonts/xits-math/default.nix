{ stdenv, fetchFromGitHub, python2Packages, fontforge }:

stdenv.mkDerivation rec {
  pname = "xits-math";
  version = "1.200";

  src = fetchFromGitHub {
    owner = "alif-type";
    repo = "xits";
    rev = "v${version}";
    sha256 = "0s1qqqg3zv9k4wqn1vkx0z895fjccg96n58syc1d5f2wba9kyfcm";
  };

  nativeBuildInputs = [ fontforge ] ++ (with python2Packages; [ python fonttools ]);

  postPatch = ''
    rm *.otf
  '';

  installPhase = ''
    install -m444 -Dt $out/share/fonts/opentype *.otf
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/khaledhosny/xits-math;
    description = "OpenType implementation of STIX fonts with math support";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
