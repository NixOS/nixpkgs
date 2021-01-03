{ stdenv, fetchFromGitHub
, cmake, cmake-extras, properties-cpp
, boost
}:

stdenv.mkDerivation rec {
  pname = "process-cpp-unstable";
  version = "2018-04-18";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "process-cpp";
    rev = "8b141209fd7f2de74a039e495357500a59c93487";
    sha256 = "0m02yzba7wbif563p4267wbgw8j6n4z9jjkf08h8zcsg7x7kbn17";
  };

  postPatch = ''
    substituteInPlace tests/CMakeLists.txt \
      --replace '$''\{GMOCK_LIBRARIES}' '$''\{GTEST_BOTH_LIBRARIES} $''\{GMOCK_LIBRARIES}'
  '';

  nativeBuildInputs = [ cmake cmake-extras properties-cpp ];

  buildInputs = [ boost ];

  outputs = [ "out" "dev" "doc" ];

  meta = with stdenv.lib; {
    description = "A simple convenience library for handling processes in C++11";
    homepage = "https://launchpad.net/process-cpp";
    license = with licenses; [ gpl3Only lgpl3Only ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
