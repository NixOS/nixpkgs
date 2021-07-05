{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "macholib";
  version = "1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DENryEfnsdm9oFYDUb9218r5MPtYWoKNE2CIOe9CxDI=";
  };

  propagatedBuildInputs = with python3Packages; [ altgraph ];

  doCheck = false;

  meta = with lib; {
    description = "Mach-O header analysis and editing";
    homepage = "https://github.com/ronaldoussoren/macholib";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
