{ lib, buildPythonPackage, fetchFromGitHub, requests, pytestCheckHook }:

buildPythonPackage rec {
  pname = "kiss-headers";
  version = "2.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Ousret";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xPjw/uJTmvmQZDrI3i1KTUeAZuDF1mc13hvFBl8Erh0=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

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
