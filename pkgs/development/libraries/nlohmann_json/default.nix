{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "nlohmann_json-${version}";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    sha256 = "192mg2y93g9q0jdn3fdffydpxk19nsrcv92kfip6srkdkwja18ri";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;
  checkTarget = "test";

  crossAttrs = {
    cmakeFlags = "-DBuildTests=OFF";
    doCheck = false;
  } // stdenv.lib.optionalAttrs (stdenv.cross.libc == "msvcrt") {
    cmakeFlags = "-DBuildTests=OFF -DCMAKE_SYSTEM_NAME=Windows";
  };

  meta = with stdenv.lib; {
    description = "Header only C++ library for the JSON file format";
    homepage = https://github.com/nlohmann/json;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
