{ lib
, buildPythonPackage
, fetchFromGitHub
, docutils
, pygments
, setuptools
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyroma";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "regebro";
    repo = pname;
    rev = version;
    sha256 = "0ln9w984n48nyxwzd1y48l6b18lnv52radcyizaw56lapcgxrzdr";
  };

  propagatedBuildInputs = [
    docutils
    pygments
    setuptools
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "pyroma/tests.py" ];

  disabledTests = [
    # PyPI tests require network access
    "PyPITest"
  ];

  pythonImportsCheck = [ "pyroma" ];

  meta = with lib; {
    description = "Test your project's packaging friendliness";
    homepage = "https://github.com/regebro/pyroma";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
