{ stdenv, fetchFromGitHub, cmake, boost, glog, leveldb, marisa, opencc,
  libyamlcpp, gmock }:

stdenv.mkDerivation rec {
  name = "librime-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "librime";
    rev = "${version}";
    sha256 = "1zkx1wfbd94v55gfycyd2b94jxclfyk2zl7yw35pyjx63qdlb6sd";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost glog leveldb marisa opencc libyamlcpp gmock ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage    = https://rime.im/;
    description = "Rime Input Method Engine, the core library";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ sifmelcara ];
    platforms   = platforms.linux;
  };
}
