{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, fetchPypi
, pythonOlder
, rapidjson
, pytestCheckHook
, pytz
, glibcLocales
}:

let
  rapidjson' = rapidjson.overrideAttrs (old: {
    version = "unstable-2023-03-06";
    src = fetchFromGitHub {
      owner = "Tencent";
      repo = "rapidjson";
      rev = "083f359f5c36198accc2b9360ce1e32a333231d9";
      hash = "sha256-8O5KwZcvoEkpE+O0Twn2CKHjV2AYh8qnSaBofoWEBs8=";
    };
    patches = [
      (fetchpatch {
        name = "do-not-include-gtest-src-dir.patch";
        url = "https://git.alpinelinux.org/aports/plain/community/rapidjson/do-not-include-gtest-src-dir.patch?id=9e5eefc7a5fcf5938a8dc8a3be8c75e9e6809909";
        hash = "sha256-BjSZEwfCXA/9V+kxQ/2JPWbc26jQn35CfN8+8NW24s4=";
      })
    ];
    # valgrind_unittest failed
    cmakeFlags = old.cmakeFlags ++ [ "-DCMAKE_CTEST_ARGUMENTS=-E;valgrind_unittest" ];
  });
in buildPythonPackage rec {
  version = "1.10";
  pname = "python-rapidjson";
  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rP7L9e25HscqIKEl3n9WuML2Fh7/TGU4LI7mokhNNUA=";
  };

  setupPyBuildFlags = [
    "--rj-include-dir=${lib.getDev rapidjson'}/include"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  disabledTestPaths = [
    "benchmarks"
  ];

  meta = with lib; {
    changelog = "https://github.com/python-rapidjson/python-rapidjson/blob/v${version}/CHANGES.rst";
    homepage = "https://github.com/python-rapidjson/python-rapidjson";
    description = "Python wrapper around rapidjson";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
