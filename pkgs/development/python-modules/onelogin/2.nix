{
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  lib,
  python-dateutil,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "onelogin";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onelogin";
    repo = "onelogin-python-sdk";
    rev = version;
    hash = "sha256-KfrYvsNr+RZOTmhJHYcLhxvKy00vUmejvcX9d1e6Rqo=";
  };

  nativeBuildInputs = [ setuptools ];

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    defusedxml
    python-dateutil
  ];

  postConfigure = ''
    substituteInPlace setup.py \
      --replace-fail "defusedxml>=0.6.0" "defusedxml"
  '';

  pythonImportsCheck = [ "onelogin" ];

  meta = with lib; {
    description = "OpenAPI Specification for OneLogin";
    homepage = "https://github.com/onelogin/onelogin-python-sdk";
    license = licenses.mit;
    maintainers = with maintainers; [ gjhenrique ];
  };
}
