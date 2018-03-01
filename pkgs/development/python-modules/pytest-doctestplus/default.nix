{ lib, buildPythonPackage, fetchPypi, six, pytest, numpy }:

buildPythonPackage rec {
  pname = "pytest-doctestplus";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07672d4a6950d5f5ad48648edd30663be9770435af5baa6c692810c39e0f6648";
  };

  propagatedBuildInputs = [ six pytest numpy ];

  checkPhase = ''
    py.test --doctest-plus --doctest-rst
  '';

  meta = with lib; {
    description = "Pytest plugin with advanced doctest features";
    homepage = https://github.com/astropy/pytest-doctestplus;
    license = licenses.bsd3;
  };
}
