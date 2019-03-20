{ stdenv, fetchFromGitHub, cmake
}:

stdenv.mkDerivation rec {
  pname = "nlohmann_json";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    sha256 = "11dfv31prfiaxxdv8ypnya4a953hqq2k94nbxl0v4qlfbsyipil3";
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
