{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyyaml,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "helper";
  version = "2.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gmr";
    repo = "helper";
    rev = version;
    hash = "sha256-99lvJDsAhrOxq+ptzBsi+iFg12hnAyDo03kzm9GW138=";
  };

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [
    "helper"
    "helper.config"
  ];

  meta = {
    description = "Development library for quickly writing configurable applications and daemons";
    homepage = "https://helper.readthedocs.org/";
    license = lib.licenses.bsd3;
  };
}
