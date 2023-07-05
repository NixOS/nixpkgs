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
    version = "unstable-2022-05-24";
    src = fetchFromGitHub {
      owner = "Tencent";
      repo = "rapidjson";
      rev = "232389d4f1012dddec4ef84861face2d2ba85709";
      hash = "sha256-RLvDcInUa8E8DRA4U/oXEE8+TZ0SDXXDU/oWvpfDWjw=";
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
  version = "1.9";
  pname = "python-rapidjson";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vn01HHES2sYIEzoj9g6VOVZo0JgaB/QDf2Pg6Ir88Bo=";
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
    homepage = "https://github.com/python-rapidjson/python-rapidjson";
    description = "Python wrapper around rapidjson";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc dotlambda ];
  };
}
