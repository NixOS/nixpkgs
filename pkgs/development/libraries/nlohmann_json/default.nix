{ lib, stdenv, fetchFromGitHub, cmake
}:

let
  testData = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json_test_data";
    rev = "5f62ed682af7dbce9a3d12853d6adf57fe7c23e0";
    sha256 = "0nzsjzlvk14dazwh7k2jb1dinb0pv9jbx5jsyn264wvva0y7daiv";
  };
in

stdenv.mkDerivation rec {
  pname = "nlohmann_json";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    sha256 = "1nldmr12pggjcybrpyiwr15xb19idhk2s4n14z1zswg4c3k7bpkl";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBuildTests=${if doCheck then "ON" else "OFF"}"
    "-DJSON_MultipleHeaders=ON"
    "-DJSON_TestDataDirectory=${testData}"
  ];

  # skip tests that require git or modify “installed files”
  preCheck = ''
    checkFlagsArray+=("ARGS=-LE 'not_reproducible|git_required'")
  '';
  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  postInstall = "rm -rf $out/lib64";

  meta = with lib; {
    description = "Header only C++ library for the JSON file format";
    homepage = "https://github.com/nlohmann/json";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
