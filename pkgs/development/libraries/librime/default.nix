{ stdenv, fetchFromGitHub, cmake, boost, glog, leveldb, marisa, opencc,
  libyamlcpp, gmock }:

stdenv.mkDerivation rec {
  pname = "librime";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "librime";
    rev = "${version}";
    sha256 = "10wvh1l4317yzcys4rzlkw42i6cj5p8g62r1xzyjw32ky2d0ndxl";
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
