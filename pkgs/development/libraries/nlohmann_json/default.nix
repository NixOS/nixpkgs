{ stdenv, fetchFromGitHub, cmake
}:

stdenv.mkDerivation rec {
  pname = "nlohmann_json";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    sha256 = "0v7xih4zjixxxfvkfbs7a8j9qcvpwlsv4vrkbyns3hc7b44nb8ap";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DBuildTests=${if doCheck then "ON" else "OFF"}"
    "-DJSON_MultipleHeaders=ON"
  ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  postInstall = "rm -rf $out/lib64";

  meta = with stdenv.lib; {
    description = "Header only C++ library for the JSON file format";
    homepage = https://github.com/nlohmann/json;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
