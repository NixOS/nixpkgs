{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "json-c";
  version = "0.16";

  src = fetchurl {
    url    = "https://s3.amazonaws.com/json-c_releases/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-jkWsj5bsd5Hq87t+5Q6cIQC7vIe40PHQMMW6igKI2Ws=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A JSON implementation in C";
    longDescription = ''
      JSON-C implements a reference counting object model that allows you to
      easily construct JSON objects in C, output them as JSON formatted strings
      and parse JSON formatted strings back into the C representation of JSON
      objects.
    '';
    homepage    = "https://github.com/json-c/json-c/wiki";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    license = licenses.mit;
  };
}
