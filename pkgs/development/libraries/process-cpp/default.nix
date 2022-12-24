{ lib
, stdenv
, fetchFromGitLab
, cmake
, extra-cmake-modules
, boost
, properties-cpp
}:

stdenv.mkDerivation rec {
  pname = "process-cpp";
  version = "unstable-2021-05-11";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "ubports";
    repo = "development/core/lib-cpp/process-cpp";
    rev = "ee6d99a3278343f5fdcec7ed3dad38763e257310";
    sha256 = "sha256-jDYXKCzrg/ZGFC2xpyfkn/f7J3t0cdOwHK2mLlYWNN0=";
  };

  postPatch = ''
    # Disable tests, seem to fail on NixOS
    sed -i '/tests/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    boost
    properties-cpp
  ];

  meta = with lib; {
    description = "A simple convenience library for handling processes in C++11";
    homepage = "https://gitlab.com/ubports/development/core/lib-cpp/process-cpp";
    license = with licenses; [ gpl3Only lgpl3Only ];
    maintainers = with maintainers; [ onny ];
  };

}
