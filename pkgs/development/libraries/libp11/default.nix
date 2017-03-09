{ stdenv, fetchFromGitHub, autoreconfHook, libtool, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libp11-0.2.7";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "libp11";
    rev = name;
    sha256 = "0llw69kcb6nvz7zzkb9nyfyhc2s972q68sqciabqxwxljr09c411";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig libtool ];
  buildInputs = [ openssl ];

  meta = {
    homepage = http://www.opensc-project.org/libp11/;
    license = "LGPL";
    description = "Small layer on top of PKCS#11 API to make PKCS#11 implementations easier";
  };
}
