{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake
}:

stdenv.mkDerivation rec {
  pname = "nlohmann_json";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    sha256 = "sha256-THordDPdH2qwk6lFTgeFmkl7iDuA/7YH71PTUe6vJCs=";
  };

  patches = [
    # https://github.com/nlohmann/json/pull/2690
    (fetchpatch {
      url = "https://github.com/nlohmann/json/commit/53a9850eebb88c6ff95f6042d08d5c0cc9d18097.patch";
      sha256 = "k+Og00nXNg5IsFQY5fWD3xVQQXUFFTie44UXole0S1M=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBuildTests=${if doCheck then "ON" else "OFF"}"
    "-DJSON_MultipleHeaders=ON"
  ];

  # A test cause the build to timeout https://github.com/nlohmann/json/issues/1816
  #doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  doCheck = false;

  postInstall = "rm -rf $out/lib64";

  meta = with lib; {
    description = "Header only C++ library for the JSON file format";
    homepage = "https://github.com/nlohmann/json";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
