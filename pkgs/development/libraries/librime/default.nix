{ lib, stdenv, fetchFromGitHub, cmake, boost, glog, leveldb, marisa, opencc,
  libyamlcpp, gtest, capnproto, pkg-config }:

stdenv.mkDerivation rec {
  pname = "librime";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "rime";
    repo = pname;
    rev = version;
    sha256 = "023c7bpfnyf8wlrssn89ziwsjccflyanrxlaqmwcbx8a5dvipk01";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ boost glog leveldb marisa opencc libyamlcpp gtest capnproto ];

  meta = with lib; {
    homepage    = "https://rime.im/";
    description = "Rime Input Method Engine, the core library";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ sifmelcara ];
    platforms   = platforms.linux;
  };
}
