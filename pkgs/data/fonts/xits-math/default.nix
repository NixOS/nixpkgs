{ lib, mkFont, fetchFromGitHub, python3Packages }:

mkFont rec {
  pname = "xits-math";
  version = "1.301";

  src = fetchFromGitHub {
    owner = "alif-type";
    repo = "xits";
    rev = "v${version}";
    sha256 = "043g0gnjc7wn1szvrs0rc1vvrq1qmhqh45b0y2kwrlxsgprpv8ll";
  };

  nativeBuildInputs = (with python3Packages; [ python fonttools fontforge ]);

  dontPatch = false;
  postPatch = ''
    rm *.otf
  '';
  dontBuild = false;

  meta = with lib; {
    homepage = "https://github.com/alif-type/xits";
    description = "OpenType implementation of STIX fonts with math support";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
