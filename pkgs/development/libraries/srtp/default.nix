{ lib, stdenv, fetchFromGitHub, pkg-config
, openssl, libpcap, cmake
}:

with lib;
stdenv.mkDerivation rec {
  pname = "libsrtp";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "libsrtp";
    rev = "v${version}";
    sha256 = "1f7i3jdh1wzdv7zjlz7gs3xw5jqig9zw8z9awsqqcp54f94xdpvd";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config cmake ];

  # libsrtp.pc references -lcrypto -lpcap without -L
  propagatedBuildInputs = [ openssl libpcap ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DENABLE_OPENSSL=ON"
    "-DBUILD_TESTING=ON"
  ];

  postInstall = ''
    rm -rf $out/bin
  '';

  doCheck = true;
  preCheck = ''
    export LD_PRELOAD=./libsrtp2.so
  '';

  meta = {
    homepage = "https://github.com/cisco/libsrtp";
    description = "Secure RTP (SRTP) Reference Implementation";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
