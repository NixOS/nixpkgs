{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  ruamel-yaml,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-param-files";
  version = "0.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "chrisjsewell";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hgEEfKf9Kmah5WDNHoFWQJKLOs9Z5BDHiebXCdDc1zE=";
  };

  nativeBuildInputs = [ flit-core ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ ruamel-yaml ];

  pythonImportsCheck = [ "pytest_param_files" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Package to generate parametrized pytests from external files";
    homepage = "https://github.com/chrisjsewell/pytest-param-files";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
  };
}
