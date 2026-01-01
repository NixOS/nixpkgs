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

<<<<<<< HEAD
  meta = {
    description = "Development library for quickly writing configurable applications and daemons";
    homepage = "https://helper.readthedocs.org/";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Development library for quickly writing configurable applications and daemons";
    homepage = "https://helper.readthedocs.org/";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
