{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "cwlformat";
  version = "2022.02.18";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rabix";
    repo = "cwl-format";
    rev = "refs/tags/${version}";
    hash = "sha256-FI8hUgb/KglTkubZ+StzptoSsYal71ITyyFNg7j48yk=";
  };

<<<<<<< HEAD
  patches = [
    # https://github.com/rabix/cwl-format/pull/21
    (fetchpatch {
      name = "fix-for-ruamel-yaml-0.17.23.patch";
      url = "https://github.com/rabix/cwl-format/commit/9d54330c73c454d2ccacd55e2d51a4145f282041.patch";
      hash = "sha256-TZGK7T2gzxMvreCLtl3nkuPrqL2KzgrO3yCNmd5lY3g=";
    })
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    ruamel-yaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cwlformat"
  ];

  meta = with lib; {
    description = "Code formatter for CWL";
    homepage = "https://github.com/rabix/cwl-format";
    changelog = "https://github.com/rabix/cwl-format/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
