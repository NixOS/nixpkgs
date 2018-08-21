{ stdenv, fetchFromGitHub, cmake
, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "nlohmann_json-${version}";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    sha256 = "1mpr781fb2dfbyscrr7nil75lkxsazg4wkm749168lcf2ksrrbfi";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBuildTests=${if doCheck then "ON" else "OFF"}"
  ] ++ stdenv.lib.optionals (hostPlatform.libc == "msvcrt") [
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
