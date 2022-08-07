{ lib
, fetchPypi
, click
, pyyaml
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec{
  pname = "panflute";
  version = "2.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AJMz+gt8Wa45aFZSLm15RjiiJlJnkWC4Lobk8o8Pu8Y=";
  };

  propagatedBuildInputs = [
    click
    pyyaml
  ];

  pythonImportsCheck = [
    "panflute"
  ];

  meta = with lib; {
    description = "Pythonic alternative to John MacFarlane's pandocfilters, with extra helper functions";
    homepage = "http://scorreia.com/software/panflute";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
