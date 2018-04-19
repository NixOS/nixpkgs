{ stdenv, fetchFromGitHub, cmake, boost, glog, leveldb, marisa, opencc,
  libyamlcpp, gmock }:

stdenv.mkDerivation rec {
  name = "librime-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "librime";
    rev = "${version}";
    sha256 = "1y0h3nnz97smx9z8h5fzk4c27mvrwv8kajxffqc43bhyvxvb2jd6";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost glog leveldb marisa opencc libyamlcpp gmock ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage    = http://rime.im/;
    description = "Rime Input Method Engine, the core library";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ sifmelcara ];
    platforms   = platforms.linux;
  };
}
