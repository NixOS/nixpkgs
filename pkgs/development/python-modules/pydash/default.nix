{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, invoke
, mock
, pytestCheckHook
, pythonOlder
, sphinx-rtd-theme
}:

buildPythonPackage rec {
  pname = "pydash";
  version = "5.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "dgilland";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BAyiSnILvujUOFOAkiXSgyozs2Q809pYihHwa+6BHcQ=";
  };

  checkInputs = [
    invoke
    mock
    sphinx-rtd-theme
    pytestCheckHook
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
    sed -i "/--no-cov/d" setup.cfg
  '';

  pythonImportsCheck = [
    "pydash"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Python utility libraries for doing stuff in a functional way";
    homepage = "https://pydash.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
