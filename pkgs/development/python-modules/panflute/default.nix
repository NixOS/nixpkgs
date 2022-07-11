{ lib
, fetchPypi
, click
, pyyaml
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec{
  pname = "panflute";
  version = "2.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7xHcWVoZh51PlonvmoOCBKJGNMpjT7z8jkoO1B65EqE=";
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
