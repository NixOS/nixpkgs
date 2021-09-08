{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake
}:

stdenv.mkDerivation rec {
  pname = "nlohmann_json";
  version = "3.10.2";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    sha256 = "/OFNfukrIyfJmD0ko174aud9T6ZOesHANJjyfk4q/Vs=";
  };

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
    description = "JSON for Modern C++";
    homepage = "https://json.nlohmann.me";
    changelog = "https://github.com/nlohmann/json/blob/develop/ChangeLog.md";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
