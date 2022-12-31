{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, roster
}:

buildPythonPackage rec {
  pname = "mediate";
  version = "0.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IgDcOY5rzXqyUpUsrFJH5D8iFJO+6mCpzzZv8stSBRc=";
  };

  propagatedBuildInputs = [
    roster
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mediate"
  ];

  meta = with lib; {
    description = "Middleware for every occasion";
    homepage = "https://github.com/tombulled/middleware";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
