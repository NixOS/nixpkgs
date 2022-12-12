{ lib
, buildPythonPackage
, fetchFromGitHub
, pefile
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dnfile";
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "malwarefrank";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-r3DupEyMEXOFeSDo9k0LmGM/TGMbbpVW7zCoUA4oG8Y=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    pefile
  ];

  checkInputs = [
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
