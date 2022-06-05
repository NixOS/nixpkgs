{ lib, stdenv, fetchFromGitHub, autoreconfHook, libtool, pkg-config
, openssl }:

stdenv.mkDerivation rec {
  pname = "libp11";
  version = "0.4.11";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "libp11";
    rev = "${pname}-${version}";
    sha256 = "0hcl706i04nw5c1sj7l6sj6m0yjq6qijz345v498jll58fp5wif8";
  };

  configureFlags = [
    "--with-enginesdir=${placeholder "out"}/lib/engines"
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config libtool ];

  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Small layer on top of PKCS#11 API to make PKCS#11 implementations easier";
    homepage = "https://github.com/OpenSC/libp11";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
