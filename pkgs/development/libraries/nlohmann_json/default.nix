{ stdenv, fetchFromGitHub, cmake
}:

stdenv.mkDerivation rec {
  name = "nlohmann_json-${version}";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    sha256 = "1plg9l1avnjsg6khrd88yj9cbzbbkwzpc5synmicqndb35wndn5h";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBuildTests=${if doCheck then "ON" else "OFF"}"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform.libc == "msvcrt") [
    "-DCMAKE_SYSTEM_NAME=Windows"
  ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  meta = with stdenv.lib; {
    description = "Header only C++ library for the JSON file format";
    homepage = https://github.com/nlohmann/json;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
