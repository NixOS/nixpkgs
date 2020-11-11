{ lib, buildPythonPackage, fetchPypi, isPy27
, vcver }:

buildPythonPackage rec {
  pname = "deepmerge";
  version = "0.1.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "07rcz699fr0jgx6i6fvh8dxa72j7745inix760nw3g46jwk487gs";
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
