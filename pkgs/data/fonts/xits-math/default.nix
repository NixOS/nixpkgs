{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "xits-math-${version}";
  version = "1.108";

  src = fetchFromGitHub {
    owner = "khaledhosny";
    repo = "xits-math";
    rev = "v${version}";
    sha256 = "08nn676c41a7gmmhrzi8mm0g74z8aiaafjk48pqcwxvjj9av7xjg";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp *.otf $out/share/fonts/opentype
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/khaledhosny/xits-math;
    description = "OpenType implementation of STIX fonts with math support";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
