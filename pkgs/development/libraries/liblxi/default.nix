{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, cmake
, libtirpc, rpcsvc-proto, avahi, libxml2
}:

stdenv.mkDerivation rec {
  pname = "liblxi";
  version = "1.18";

  src = fetchFromGitHub {
    owner = "lxi-tools";
    repo = "liblxi";
    rev = "v${version}";
    sha256 = "sha256-2tZWIN58J6zNHG3dahNfg5eNiS8ykWFQyRSyikuzdjE=";
  };

  nativeBuildInputs = [ meson ninja cmake pkg-config rpcsvc-proto ];

  buildInputs = [ libtirpc avahi libxml2 ];

  meta = with lib; {
    description = "Library for communicating with LXI compatible instruments";
    longDescription = ''
      liblxi is an open source software library which offers a simple
      API for communicating with LXI compatible instruments.
      The API allows applications to easily discover instruments
      on networks and communicate SCPI commands.
    '';
    homepage = "https://lxi-tools.github.io/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.vq ];
  };
}
