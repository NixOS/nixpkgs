{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "nlohmann_json-${version}";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    sha256 = "10sk8d23vh0c7b3qafjz2n8r5jv8vc275bl069ikhqnx1zxv6hwp";
  };

  buildInputs = [ cmake ];

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Header only C++ library for the JSON file format";
    homepage = https://github.com/nlohmann/json;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
