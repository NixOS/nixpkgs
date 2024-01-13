{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, jsbeautifier
}:

buildPythonPackage rec {
  pname = "cssbeautifier";
  version = "1.14.11";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QFRMK2K7y2TKpefzegLflWVOXOG8rK2sTKHz3InDFRM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ jsbeautifier ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "cssbeautifier" ];

  meta = with lib; {
    description = "CSS unobfuscator and beautifier";
    homepage = "https://pypi.org/project/cssbeautifier/";
    license = licenses.mit;
    maintainers = with maintainers; [ traxys ];
  };
}
