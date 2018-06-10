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

  doCheck = true;
  checkTarget = "test";

  enableParallelBuilding = true;

  crossAttrs = {
    cmakeFlags = "-DBuildTests=OFF";
    doCheck = false;
  } // stdenv.lib.optionalAttrs (hostPlatform.libc == "msvcrt") {
    cmakeFlags = "-DBuildTests=OFF -DCMAKE_SYSTEM_NAME=Windows";
  };

  meta = with stdenv.lib; {
    description = "Header only C++ library for the JSON file format";
    homepage = https://github.com/nlohmann/json;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
