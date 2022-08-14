{ lib
, fetchFromGitHub
, stdenv
, cmake
, substituteAll
}:

stdenv.mkDerivation {
  pname = "libsodium-cmake";
  version = "revf73a3fe";

  src = fetchFromGitHub {
    owner = "AmineKhaldi";
    repo = "libsodium-cmake";
    rev = "f73a3fe1afdc4e37ac5fe0ddd401bf521f6bba65";
    sha256 = "sha256-lGz7o6DQVAuEc7yTp8bYS2kwjzHwGaNjugDi1ruRJOA=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DSODIUM_MINIMAL=true"
    "-DSODIUM_DISABLE_TESTS=true"
  ];

  installPhase = ''
    ls
    echo $out
    ls $out
  '';

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/AmineKhaldi/libsodium-cmake";
    description = "Wrapper around the libsodium repository providing good integration with CMake when using FetchContent or adding it as a submodule.";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abueide ];
  };
}
