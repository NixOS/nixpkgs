{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, enableStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "liboqs";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "open-quantum-safe";
    repo = pname;
    rev = version;
    sha256 = "sha256-h3mXoGRYgPg0wKQ1u6uFP7wlEUMQd5uIBt4Hr7vjNtA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if enableStatic then "OFF" else "ON"}"
    "-DOQS_DIST_BUILD=ON"
    "-DOQS_BUILD_ONLY_LIB=ON"
  ];

  dontFixCmake = true; # fix CMake file will give an error

  meta = with lib; {
    description = "C library for prototyping and experimenting with quantum-resistant cryptography";
    homepage = "https://openquantumsafe.org";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [];
  };
}
