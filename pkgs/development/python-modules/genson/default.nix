{ lib
, python3
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, unittestCheckHook
, setuptools
, jsonschema
}:

buildPythonPackage rec {
  pname = "genson";
  version = "1.3.0";

  pyproject = true;

  disabled = pythonOlder "3.7";

  # The Pypi tarball doesn't contain some test data
  src = fetchFromGitHub {
    owner = "wolverdude";
    repo = "GenSON";
    rev = "v${version}";
    hash = "sha256-Bb2PRuZuj/yotb78MbLgVwi4Fz7hbnXJmoXTe4kg43k=";
  };

  build-system = [ setuptools ];

  dependencies = [ jsonschema ];

  nativeCheckInputs = [ unittestCheckHook ];

  preInstall = ''
    export PYTHONPATH="$out/${python3.sitePackages}:$PYTHONPATH"
  '';

  # pythonImportsCheck = [ "genson" ];

  meta = with lib; {
    description = "A powerful, user-friendly JSON Schema generator built in Python";
    homepage = "https://github.com/wolverdude/GenSON/";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };
}
