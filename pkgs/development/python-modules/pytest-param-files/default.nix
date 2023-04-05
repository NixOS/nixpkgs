{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-param-files";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "chrisjsewell";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Q7wWoggJN2w2a2umQHx5TsVcugqpovBEtOKruNMZQ8A=";
  };

  format = "flit";

  nativeBuildInputs = [ flit-core ];

  buildInputs = [
    pytest
  ];

  pythonImportsCheck = [ "pytest_param_files" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Package to generate parametrized pytests from external files";
    homepage = "https://github.com/chrisjsewell/pytest-param-files";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
  };
}
