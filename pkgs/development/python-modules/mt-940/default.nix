{ lib, buildPythonPackage, fetchPypi, isPy3k
, enum34, pyyaml, pytest
}:

buildPythonPackage rec {
  version = "4.27.0";
  pname = "mt-940";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LL4CRioio63gpXrsurVucrkFgQrEh0gZPZ79Y2tk/90=";
  };

  propagatedBuildInputs = lib.optional (!isPy3k) enum34;

  checkInputs = [ pyyaml pytest ];

  # requires tests files that are not present
  doCheck = false;
  checkPhase = ''
    py.test
  '';

  pythonImportsCheck = [ "mt940" ];

  meta = with lib; {
    description = "A library to parse MT940 files and returns smart Python collections for statistics and manipulation";
    homepage = "https://github.com/WoLpH/mt940";
    license = licenses.bsd3;
  };
}
