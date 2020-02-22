{lib, fetchPypi, buildPythonPackage, numpy, pyparsing}:

buildPythonPackage rec{
  pname = "periodictable";
  version = "1.5.2";

  propagatedBuildInputs = [numpy pyparsing];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lx03xirh3hcrzkwrz91dmdzcj01bykq59hccd83ai901jzqmshz";
  };

  meta = {
    homepage = http://www.reflectometry.org/danse/software.html;
    description = "an extensible periodic table of the elements prepopulated with data important to neutron and x-ray scattering experiments";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
