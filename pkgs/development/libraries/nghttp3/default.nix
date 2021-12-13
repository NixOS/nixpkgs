{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, cunit, file
}:

stdenv.mkDerivation rec {
  pname = "nghttp3";
  version = "unstable-2021-11-10";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "270e75447ed9e2a05b78ba89d0699d076230ea60";
    sha256 = "01cla03cv8nd2rf5p77h0xzvn9f8sfwn8pp3r2jshvqp9ipa8065";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config cunit file ];

  preConfigure = ''
    substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
  '';

  outputs = [ "out" "dev" ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/nghttp3";
    description = "nghttp3 is an implementation of HTTP/3 mapping over QUIC and QPACK in C.";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
  };
}
