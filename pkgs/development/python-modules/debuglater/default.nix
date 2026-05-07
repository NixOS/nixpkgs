{
  lib,
  buildPythonPackage,
  colorama,
  dill,
  fetchFromGitHub,
  numpy,
  pandas,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "debuglater";
  version = "1.4.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ploomber";
    repo = "debuglater";
    tag = version;
    hash = "sha256-o9IAk3EN8ghEft7Y7Xx+sEjWMNgoyiZ0eiBqnCyXkm8=";
  };

  propagatedBuildInputs = [ colorama ];

  optional-dependencies = {
    all = [ dill ];
  };

  nativeCheckInputs = [
    numpy
    pandas
    pytestCheckHook
  ]
  ++ optional-dependencies.all;

  pythonImportsCheck = [ "debuglater" ];

  meta = {
    description = "Module for post-mortem debugging of Python programs";
    homepage = "https://github.com/ploomber/debuglater";
    changelog = "https://github.com/ploomber/debuglater/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
