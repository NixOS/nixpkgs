{ stdenv, fetchFromGitHub, cmake
}:

stdenv.mkDerivation rec {
  pname = "nlohmann_json";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    sha256 = "09l2kf7hrnf8xb7k6b2271imggyqcyvz83xf9k730prdzxy997y7";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBuildTests=${if doCheck then "ON" else "OFF"}"
    "-DJSON_MultipleHeaders=ON"
  ];

  # A test cause the build to timeout https://github.com/nlohmann/json/issues/1816
  #doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  doCheck = false;

  postInstall = "rm -rf $out/lib64";

  meta = with stdenv.lib; {
    description = "Header only C++ library for the JSON file format";
    homepage = "https://github.com/nlohmann/json";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
