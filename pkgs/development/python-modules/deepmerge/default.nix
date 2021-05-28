{ lib, buildPythonPackage, fetchPypi, isPy27
, vcver }:

buildPythonPackage rec {
  pname = "deepmerge";
  version = "0.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d1ab9lxwymqxxd58j50id1wib48xym3ss5xw172i2jfwwwzfdrx";
  };

  propagatedBuildInputs = [
    vcver
  ];

  # depends on https://pypi.org/project/uranium/
  doCheck = false;

  pythonImportsCheck = [ "deepmerge" ];

  meta = with lib; {
    description = "A toolset to deeply merge python dictionaries.";
    homepage = "http://deepmerge.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
