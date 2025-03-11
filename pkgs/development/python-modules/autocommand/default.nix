{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "autocommand";
  version = "2.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Lucretiel";
    repo = "autocommand";
    tag = version;
    hash = "sha256-9bv9Agj4RpeyNJvTLUaMwygQld2iZZkoLb81rkXOd3E=";
  };

  postPatch = ''
    #  _MissingDynamic: `license` defined outside of `pyproject.toml` is ignored.
    rm setup.py
  '';

  nativeBuildInputs = [ setuptools ];

  # fails with: SyntaxError: invalid syntax
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "autocommand" ];

  meta = with lib; {
    description = "Autocommand turns a python function into a CLI program";
    homepage = "https://github.com/Lucretiel/autocommand";
    license = licenses.lgpl3Only;
    maintainers = [ ];
  };
}
