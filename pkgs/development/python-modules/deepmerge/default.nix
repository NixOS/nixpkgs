{ lib, buildPythonPackage, fetchPypi, isPy27
, vcver }:

buildPythonPackage rec {
  pname = "deepmerge";
  version = "0.1.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa1d44269786bcc12d30a7471b0b39478aa37a43703b134d7f12649792f92c1f";
  };

  requiredPythonModules = [
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
