{ lib
, buildPythonPackage
, cssselect
, fetchPypi
, jmespath
, lxml
, packaging
, psutil
, pytestCheckHook
, pythonOlder
, w3lib
}:

buildPythonPackage rec {
  pname = "parsel";
  version = "1.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-paa8sMX8dBVAujB1Y2/1y5aIUqeMwWroIlDl1Ib6fUg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  propagatedBuildInputs = [
    cssselect
    jmespath
    lxml
    packaging
    w3lib
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "parsel"
  ];

  meta = with lib; {
    description = "Python library to extract data from HTML and XML using XPath and CSS selectors";
    homepage = "https://github.com/scrapy/parsel";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
