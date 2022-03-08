{ lib, buildPythonPackage, fetchFromGitHub, requests, pytestCheckHook }:

buildPythonPackage rec {
  pname = "kiss-headers";
  version = "2.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Ousret";
    repo = pname;
    rev = version;
    sha256 = "sha256-/eTRyxFyAKQMzE/JjdoEN3w0lRiaIJcsJHTWV8M0CYQ=";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=kiss_headers --doctest-modules --cov-report=term-missing -rxXs" "--doctest-modules -rxXs"
  '';

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
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
