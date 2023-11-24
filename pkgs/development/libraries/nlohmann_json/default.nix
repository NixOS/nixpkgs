{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
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
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SUdhIV7tjtacf5DkoWk9cnkfyMlrkg8ZU7XnPZd22Tw=";
  };

  patches = [
    # Backport fix for gcc-13:
    #   https://github.com/nlohmann/json/pull/3895
    (fetchpatch {
      name = "gcc-13-rebind.patch";
      url = "https://github.com/nlohmann/json/commit/a5b09d50b786638ed9deb09ef13860a3cb64eb6b.patch";
      hash = "sha256-Jbi0VwZP+ZHTGbpIwgKCVc66gOmwjkT5iOUe85eIzM0=";
    })

    # Backport fix for gcc-13:
    #   https://github.com/nlohmann/json/pull/3950
    (fetchpatch {
      name = "gcc-13-eq-op.patch";
      url = "https://github.com/nlohmann/json/commit/a49829bd984c0282be18fcec070df0c31bf77dd5.patch";
      hash = "sha256-D+cRtdN6AXr4z3/y9Ui7Zqp3e/y10tp+DOL80ZtPz5E=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DJSON_BuildTests=${if finalAttrs.doCheck then "ON" else "OFF"}"
    "-DJSON_FastTests=ON"
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
