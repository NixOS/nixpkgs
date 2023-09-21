{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "httpunit";
  version = "1.7";

  src = fetchurl {
    url = "mirror://sourceforge/httpunit/httpunit-${version}.zip";
    sha256 = "09gnayqgizd8cjqayvdpkxrc69ipyxawc96aznfrgdhdiwv8l5zf";
  };

  buildCommand = ''
    cp ./* $out
  '';

  meta = with lib; {
    homepage = "https://httpunit.sourceforge.net";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
