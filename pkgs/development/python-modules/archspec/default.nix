{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, jsonschema
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "archspec";
<<<<<<< HEAD
  version = "0.2.1";
=======
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-2rMsxSAnPIVqvsbAUtBbHLb3AvrZFjGzxYO6A/1qXnY=";
=======
    hash = "sha256-Zu7/zx3FTVJVGpAdRDdnLBokeodspZg6ou/GBaqz4XY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [
    "archspec"
  ];

  meta = with lib; {
    description = "Library for detecting, labeling, and reasoning about microarchitectures";
    homepage = "https://archspec.readthedocs.io/";
<<<<<<< HEAD
    changelog = "https://github.com/archspec/archspec/releases/tag/v0.2.1";
=======
    changelog = "https://github.com/archspec/archspec/releases/tag/v0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ atila ];
  };
}
