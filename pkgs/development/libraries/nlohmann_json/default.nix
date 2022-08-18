{ stdenv
, lib
, fetchFromGitHub
, cmake
}:
let
  testData = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json_test_data";
    rev = "v3.0.0";
    sha256 = "O6p2PFB7c2KE9VqWvmTaFywbW1hSzAP5V42EuemX+ls=";
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "nlohmann_json";
  version = "3.10.5";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${finalAttrs.version}";
    sha256 = "DTsZrdB9GcaNkx7ZKxcgCA3A9ShM5icSF0xyGguJNbk=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBuildTests=${lib.boolToCMakeString finalAttrs.doCheck}"
    "-DJSON_MultipleHeaders=ON"
  ] ++ lib.optional finalAttrs.doCheck "-DJSON_TestDataDirectory=${testData}";

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
