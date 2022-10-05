{ lib, stdenv
, cmake
, fetchFromGitHub
, openssl
, c-ares
, tl-expected
}:

stdenv.mkDerivation rec {
  pname = "libcoro";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "jstranik";
    repo = "libcoro";
    rev = "459692cad0bd4814e2bc655f39d406897af07a4a";
    sha256 = "sha256-tZRCRKG8J9Ngk5x0d1eydziBW32HwmI8GIQRIzckL7Q=";
    fetchSubmodules = true;
    # url = "https://github.com/jbaldwin/libcoro.git";
    # rev = "main";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake  ];

  propagatedBuildInputs = [ c-ares openssl.dev tl-expected];
  #buildInputs = [ openssl.dev ];
  #patches = [ ./cmake_install.patch ];
  #patchFlags = [ "-p2" ];

  meta = with lib; {
    homepage = "https://github.com/jbaldwin/libcoro";
    description = "A C++20 coroutine library";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ jstranik ];
  };
}
