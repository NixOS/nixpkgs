{ stdenv, fetchFromGitHub, pkgconfig
, openssl ? null, libpcap ? null
}:

with stdenv.lib;
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

  nativeBuildInputs = [ pkgconfig ];

  # libsrtp.pc references -lcrypto -lpcap without -L
  propagatedBuildInputs = [ openssl libpcap ];

  configureFlags = [
    "--disable-debug"
  ] ++ optional (openssl != null) "--enable-openssl";

  buildFlags = [ "shared_library" ];

  postInstall = ''
    rm -rf $out/bin
  '';

  meta = {
    homepage = https://github.com/cisco/libsrtp;
    description = "Secure RTP (SRTP) Reference Implementation";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
