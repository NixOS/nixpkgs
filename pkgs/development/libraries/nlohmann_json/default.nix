{ stdenv, fetchFromGitHub, cmake
, multipleHeaders ? false
}:

stdenv.mkDerivation rec {
  pname = "nlohmann_json";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    sha256 = "1dgx3j9pb0f52dh73z8dpwdy79bra1qi5vpl66b9inq4gamf813z";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags =
    [ "-DBuildTests=${if doCheck then "ON" else "OFF"}" ]
    ++ stdenv.lib.optional multipleHeaders "-DJSON_MultipleHeaders=ON";

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  meta = with stdenv.lib; {
    description = "Header only C++ library for the JSON file format";
    homepage = https://github.com/nlohmann/json;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
