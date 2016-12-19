{ stdenv, fetchFromGitHub, pkgconfig
, openssl ? null, libpcap ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libsrtp-${version}";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "libsrtp";
    rev = "v${version}";
    sha256 = "0s029m4iw0nsvnsm2hlz8yajrasdvf315iv2dw8mfm7nhbshwsqa";
  };

  buildInputs = [ pkgconfig ];

  # libsrtp.pc references -lcrypto -lpcap without -L
  propagatedBuildInputs = [ openssl libpcap ];

  configureFlags = [
    "--disable-debug"
  ] ++ optional (openssl != null) "--enable-openssl";

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
