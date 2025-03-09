{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pefile,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dnfile";
  version = "0.15.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "malwarefrank";
    repo = "dnfile";
    rev = "refs/tags/v${version}";
    hash = "sha256-AdGXcdoBNWZ4f8NBP50Fp3in1FTVPFDifGhjeAfp46M=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [ pefile ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dnfile" ];

  meta = with lib; {
    description = "Module to parse .NET executable files";
    homepage = "https://github.com/malwarefrank/dnfile";
    changelog = "https://github.com/malwarefrank/dnfile/blob/v${version}/HISTORY.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
