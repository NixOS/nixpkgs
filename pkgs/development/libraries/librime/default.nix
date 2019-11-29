{ stdenv, fetchFromGitHub, cmake, boost, glog, leveldb, marisa, opencc,
  libyamlcpp, gmock }:

stdenv.mkDerivation rec {
  pname = "librime";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "librime";
    rev = version;
    sha256 = "0xskhdhk7dgpc71r39pfzxi5vrlzy90aqj1gzv8nnapq91p2awhv";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost glog leveldb marisa opencc libyamlcpp gmock ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage    = "https://rime.im/";
    description = "Rime Input Method Engine, the core library";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ sifmelcara ];
    platforms   = platforms.linux;
  };
}
