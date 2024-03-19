{ lib
, fetchPypi
, click
, pyyaml
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec{
  pname = "panflute";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zv2d/EjM2XMqU9tXYQcB0igG2jl6ipflzI3AcLVYZco=";
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
    changelog = "https://github.com/sergiocorreia/panflute/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ synthetica ];
  };
}
