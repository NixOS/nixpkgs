{ lib
, buildPythonPackage
, fetchFromGitHub
, pefile
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dnfile";
  version = "0.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "malwarefrank";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-TH30gEoxXkaDac6hJsGQFWzwDeqzdZ19HK8i/3Dlh8k=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

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
