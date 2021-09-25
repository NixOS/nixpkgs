{lib, fetchPypi, buildPythonPackage, numpy, pyparsing, pytest-cov, pytestCheckHook }:

buildPythonPackage rec {
  pname = "periodictable";
  version = "1.6.0";

  propagatedBuildInputs = [numpy pyparsing];

  src = fetchPypi {
    inherit pname version;
    sha256 = "52e925220005c20e97601e7b04ad6cebc271680947ab9adcbb1a796ddbaa0f23";
  };

  checkInputs = [ pytest-cov pytestCheckHook ];

  meta = {
    homepage = "https://www.reflectometry.org/danse/software.html";
    description = "an extensible periodic table of the elements prepopulated with data important to neutron and x-ray scattering experiments";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
