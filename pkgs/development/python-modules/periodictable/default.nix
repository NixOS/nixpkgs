{lib, fetchPypi, buildPythonPackage, numpy, pyparsing, pytest-cov, pytestCheckHook }:

buildPythonPackage rec {
  pname = "periodictable";
  version = "1.6.1";

  propagatedBuildInputs = [numpy pyparsing];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fFAcn3PXex+yjLUehbKEKcLESpnOPRJ0iUVkxy1xJgM=";
  };

  checkInputs = [ pytest-cov pytestCheckHook ];

  meta = {
    homepage = "https://www.reflectometry.org/danse/software.html";
    description = "an extensible periodic table of the elements prepopulated with data important to neutron and x-ray scattering experiments";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
