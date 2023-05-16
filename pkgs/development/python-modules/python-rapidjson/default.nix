{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
<<<<<<< HEAD
=======
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, rapidjson
, pytestCheckHook
, pytz
, glibcLocales
}:

let
  rapidjson' = rapidjson.overrideAttrs (old: {
<<<<<<< HEAD
    version = "unstable-2023-03-06";
    src = fetchFromGitHub {
      owner = "Tencent";
      repo = "rapidjson";
      rev = "5e17dbed34eef33af8f3e734820b5dc547a2a3aa";
      hash = "sha256-CTy42X6P6+Gz4WbJ3tCpAw3qqlJ+mU1PaWW9LGG+6nU=";
=======
    version = "unstable-2022-05-24";
    src = fetchFromGitHub {
      owner = "Tencent";
      repo = "rapidjson";
      rev = "232389d4f1012dddec4ef84861face2d2ba85709";
      hash = "sha256-RLvDcInUa8E8DRA4U/oXEE8+TZ0SDXXDU/oWvpfDWjw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "1.11";
  pname = "python-rapidjson";
  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "python-rapidjson";
    repo = "python-rapidjson";
    rev = "refs/tags/v${version}";
    hash = "sha256-Jnnr4MCopx2YJTqbHqSCzPBzUl0T8SqcznRGSI14d2Q=";
=======
  version = "1.9";
  pname = "python-rapidjson";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vn01HHES2sYIEzoj9g6VOVZo0JgaB/QDf2Pg6Ir88Bo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/python-rapidjson/python-rapidjson/blob/${src.rev}/CHANGES.rst";
    homepage = "https://github.com/python-rapidjson/python-rapidjson";
    description = "Python wrapper around rapidjson";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
=======
    homepage = "https://github.com/python-rapidjson/python-rapidjson";
    description = "Python wrapper around rapidjson";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc dotlambda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
