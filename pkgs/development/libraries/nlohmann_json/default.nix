{ stdenv, fetchFromGitHub, cmake
}:

stdenv.mkDerivation rec {
  name = "nlohmann_json-${version}";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    sha256 = "1140gz5za7yvfcphdgxaq1dm4b1vxy1m8d1w0s0smv4vvdvl26ym";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBuildTests=${if doCheck then "ON" else "OFF"}"
  ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  meta = with stdenv.lib; {
    description = "Header only C++ library for the JSON file format";
    homepage = https://github.com/nlohmann/json;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
