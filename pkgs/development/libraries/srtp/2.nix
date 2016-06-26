{ stdenv, fetchFromGitHub, pkgconfig
, openssl ? null, libpcap ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libsrtp2-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "libsrtp";
    rev = "v${version}";
    sha256 = "1ilrqryvnspbkfnzy1f4pgcjb9765d1z4cx7m9g8hxn0wx5rmysg";
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
