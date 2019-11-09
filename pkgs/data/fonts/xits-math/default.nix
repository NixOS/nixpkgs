{ stdenv, fetchFromGitHub, python2Packages, fontforge }:

stdenv.mkDerivation rec {
  pname = "xits-math";
  version = "1.301";

  src = fetchFromGitHub {
    owner = "alif-type";
    repo = "xits";
    rev = "v${version}";
    sha256 = "043g0gnjc7wn1szvrs0rc1vvrq1qmhqh45b0y2kwrlxsgprpv8ll";
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
