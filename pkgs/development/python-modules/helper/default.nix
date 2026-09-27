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
    sha256 = "0zypjv8rncvrsgl200v7d3bn08gs48dwqvgamfqv71h07cj6zngp";
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
    homepage = "https://github.com/gmr/helper";
    license = lib.licenses.bsd3;
  };
}
