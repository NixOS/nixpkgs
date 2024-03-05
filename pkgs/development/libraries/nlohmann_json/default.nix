{ stdenv
, lib
, fetchFromGitHub
, cmake
}:
let
  testData = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json_test_data";
    rev = "v3.1.0";
    hash = "sha256-bG34W63ew7haLnC82A3lS7bviPDnApLipaBjJAjLcVk=";
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "nlohmann_json";
  version = "3.11.3";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7F0Jon+1oWL7uqet5i1IgHX0fUw/+z0QwEcA3zs5xHg=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DJSON_BuildTests=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
    "-DJSON_FastTests=ON"
    "-DJSON_MultipleHeaders=ON"
  ] ++ lib.optional finalAttrs.finalPackage.doCheck "-DJSON_TestDataDirectory=${testData}";

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  # skip tests that require git or modify “installed files”
  preCheck = ''
    checkFlagsArray+=("ARGS=-LE 'not_reproducible|git_required'")
  '';

  postInstall = "rm -rf $out/lib64";

  meta = with lib; {
    description = "JSON for Modern C++";
    homepage = "https://json.nlohmann.me";
    changelog = "https://github.com/nlohmann/json/blob/develop/ChangeLog.md";
    license = licenses.mit;
    platforms = platforms.all;
  };
})
