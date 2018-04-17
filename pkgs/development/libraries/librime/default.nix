{ stdenv, fetchFromGitHub, cmake, boost, glog, leveldb, marisa, opencc,
  libyamlcpp, gmock }:

stdenv.mkDerivation rec {
  name = "librime-${version}";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "librime";
    rev = "${version}";
    sha256 = "1sxxxliqjjsfblx9n6ijw9gx40xqw71v352b28aw51gg3k201v0j";
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
