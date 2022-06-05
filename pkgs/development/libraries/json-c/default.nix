{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "json-c";
  version = "0.15";

  src = fetchurl {
    url    = "https://s3.amazonaws.com/json-c_releases/releases/${pname}-${version}.tar.gz";
    sha256 = "1im484iz08j3gmzpw07v16brwq46pxxj65i996kkp2vivcfhmn5q";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A JSON implementation in C";
    homepage    = "https://github.com/json-c/json-c/wiki";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    license = licenses.mit;

    longDescription = ''
      JSON-C implements a reference counting object model that allows you to
      easily construct JSON objects in C, output them as JSON formatted strings
      and parse JSON formatted strings back into the C representation of JSON
      objects.
    '';
  };
}
