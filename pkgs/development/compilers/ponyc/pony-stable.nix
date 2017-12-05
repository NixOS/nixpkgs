{stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation rec {
  name = "pony-stable-${version}";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "pony-stable";
    rev = version;
    sha256 = "0q05135mnzzdwam7cnmxq34clqhmc83yp2gi63sx20c74rcw3p6v";
  };

  buildInputs = [ ponyc ];

  installPhase = ''
    make prefix=$out install
  '';

  meta = {
    description = "A simple dependency manager for the Pony language.";
    homepage = http://www.ponylang.org;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ dipinhora kamilchm ];
    platforms = stdenv.lib.platforms.unix;
  };
}
