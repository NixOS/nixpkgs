{ lib
, python
, buildPythonPackage
, fetchPypi
, python-utils
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14d3165a1781d053ffaa117daf27cc706128d2ec1d2977fdb05b6bb079888013";
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
