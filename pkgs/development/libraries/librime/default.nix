{ stdenv, fetchFromGitHub, cmake, boost, glog, leveldb, marisa, opencc,
  libyamlcpp, gmock }:

stdenv.mkDerivation rec {
  name = "librime-${version}";
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "librime";
    rev = "rime-${version}";
    sha256 = "14jgnfm61ynm086x9v7wfmv2p14h0qp8lq4d2jqm21n821jsraj6";
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
