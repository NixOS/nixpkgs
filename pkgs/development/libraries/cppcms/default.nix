{ lib, stdenv, fetchurl, cmake, pcre, zlib, python3, openssl }:

stdenv.mkDerivation rec {
  pname = "cppcms";
  version = "2.0.0.beta2";

  src = fetchurl {
    url = "mirror://sourceforge/cppcms/${pname}-${version}.tar.bz2";
    sha256 = "sha256-aXAxx9FB/dIVxr5QkLZuIQamO7PlLwnugSDo78bAiiE=";
  };

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ pcre zlib openssl ];

  strictDeps = true;

  cmakeFlags = [
    "--no-warn-unused-cli"
  ];

  meta = with lib; {
    homepage = "http://cppcms.com";
    description = "High Performance C++ Web Framework";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.juliendehos ];
  };
}
