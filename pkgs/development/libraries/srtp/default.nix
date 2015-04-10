{ stdenv, fetchFromGitHub, pkgconfig
, openssl ? null, libpcap ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libsrtp-${version}";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "libsrtp";
    rev = "v${version}";
    sha256 = "0iy1il72gnjcwbi16wf4kzdqs1xx8is9qvs6m49pg37218s26gdw";
  };

  buildInputs = [ pkgconfig ];

  # libsrtp.pc references -lcrypto -lpcap without -L
  propagatedBuildInputs = [ openssl libpcap ];

  configureFlags = [
    "--disable-debug"
  ] ++ optional (openssl != null) "--enable-openssl";

  postInstall = ''
    rmdir $out/bin
  '';

  meta = {
    homepage = https://github.com/cisco/libsrtp;
    description = "Secure RTP (SRTP) Reference Implementation";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
