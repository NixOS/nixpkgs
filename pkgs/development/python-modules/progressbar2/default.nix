{ lib
, python
, buildPythonPackage
, fetchPypi
, python-utils
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-E5OSL8tkWYlErUV1afvrSzrBie9Qta25zvMoTofjlM4=";
  };

  propagatedBuildInputs = [ python-utils ];

  pythonImportsCheck = [ "progressbar" ];

  meta = with lib; {
    homepage = "https://progressbar-2.readthedocs.io/en/latest/";
    description = "Text progressbar library for python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman turion ];
  };
}
