{ stdenv, fetchFromGitHub, cmake, boost, glog, leveldb, marisa, opencc,
  libyamlcpp, gmock }:

stdenv.mkDerivation rec {
  name = "librime-${version}";
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "librime";
    rev = "rime-${version}";
    sha256 = "1dah5clq3x8lrr2fyacyj4s4kicqaah2q6qm93l1621nm5qj3k1j";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost glog leveldb marisa opencc libyamlcpp gmock ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage    = http://rime.im/;
    description = "Rime Input Method Engine, the core library";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ sifmelcara ];
    platforms   = platforms.all;
  };
}
