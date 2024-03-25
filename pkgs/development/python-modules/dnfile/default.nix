{ lib
, buildPythonPackage
, fetchFromGitHub
, pefile
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "dnfile";
  version = "0.15.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "malwarefrank";
    repo = "dnfile";
    rev = "refs/tags/v${version}";
    hash = "sha256-HzlMJ4utBHyLLhO+u0uiTfqtk8jX80pEyO75QvpJ3yg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pefile
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dnfile"
  ];

  meta = with lib; {
    description = "Module to parse .NET executable files";
    homepage = "hhttps://github.com/malwarefrank/dnfile";
    changelog = "https://github.com/malwarefrank/dnfile/blob/v${version}/HISTORY.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
