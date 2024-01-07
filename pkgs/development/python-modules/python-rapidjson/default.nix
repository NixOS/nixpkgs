{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
      rev = "5e17dbed34eef33af8f3e734820b5dc547a2a3aa";
      hash = "sha256-CTy42X6P6+Gz4WbJ3tCpAw3qqlJ+mU1PaWW9LGG+6nU=";
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
  version = "1.14";
  pname = "python-rapidjson";
  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "python-rapidjson";
    repo = "python-rapidjson";
    rev = "refs/tags/v${version}";
    hash = "sha256-fCC6jYUIB89HlEnbsmL0MeCBOO4NAZtePuPgZKYxoM8=";
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
    changelog = "https://github.com/python-rapidjson/python-rapidjson/blob/${src.rev}/CHANGES.rst";
    homepage = "https://github.com/python-rapidjson/python-rapidjson";
    description = "Python wrapper around rapidjson";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
