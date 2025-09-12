{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "kiss-headers";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ousret";
    repo = "kiss-headers";
    tag = version;
    hash = "sha256-h0e7kFbn6qxIeSG85qetBg6IeSi/2YAaZLGS0+JH2g8=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  disabledTestPaths = [
    # Tests require internet access
    "kiss_headers/__init__.py"
    "tests/test_serializer.py"
    "tests/test_with_http_request.py"
  ];

  pythonImportsCheck = [ "kiss_headers" ];

  meta = with lib; {
    description = "Python package for HTTP/1.1 style headers";
    homepage = "https://github.com/Ousret/kiss-headers";
    license = licenses.mit;
    maintainers = [ ];
  };
}
