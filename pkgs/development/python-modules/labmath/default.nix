{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "labmath";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/fZ61tJ6PVZsubr3OXlbg/VxyyKimz36uPV+r33kgD0=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "labmath/DESCRIPTION.rst" "PKG-INFO"
  '';

  pythonImportsCheck = [ "labmath" ];

  meta = with lib; {
    homepage = "https://pypi.org/project/labmath";
    description = "Module for basic math in the general vicinity of computational number theory";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
