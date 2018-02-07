{stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation rec {
  name = "pony-stable-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "pony-stable";
    rev = version;
    sha256 = "0v4039iijjv93m89s3dsikcbp1y0hml6g1agj44s6w2g4m8kiiw3";
  };

  buildInputs = [ ponyc ];

  installPhase = ''
    make prefix=$out install
  '';

  meta = {
    description = "A simple dependency manager for the Pony language.";
    homepage = https://www.ponylang.org;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ dipinhora kamilchm ];
    platforms = stdenv.lib.platforms.unix;
  };
}
