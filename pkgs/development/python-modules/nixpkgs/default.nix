{ lib
, buildPythonPackage
, fetchPypi
, pbr
, pythonix
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "nixpkgs";
  version = "0.2.4";
  format = "setuptools";
  disabled = ! pythonAtLeast "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dlvq4bpamhlva86042wlc0xxfsxlpdgm2adfb1c6y3vjgbm0nvd";
  };

  buildInputs = [ pbr ];
  propagatedBuildInputs = [ pythonix ];

  # does not have any tests
  doCheck = false;
  pythonImportsCheck = [ "nixpkgs" ];

  meta = with lib; {
    description = "Allows to `from nixpkgs import` stuff in interactive Python sessions";
    homepage = "https://github.com/t184256/nixpkgs-python-importer";
    license = licenses.mit;
    maintainers = with maintainers; [ t184256 ];
  };

}
