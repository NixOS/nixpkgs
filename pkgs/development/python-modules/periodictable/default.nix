{lib, fetchPypi, buildPythonPackage, numpy, pyparsing}:

buildPythonPackage rec {
  pname = "periodictable";
  version = "1.5.3";

  propagatedBuildInputs = [numpy pyparsing];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d09c359468e2de74b43fc3a7dcb0d3d71e0ff53adb85995215d8d7796451af6";
  };

  meta = {
    homepage = "https://www.reflectometry.org/danse/software.html";
    description = "an extensible periodic table of the elements prepopulated with data important to neutron and x-ray scattering experiments";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
