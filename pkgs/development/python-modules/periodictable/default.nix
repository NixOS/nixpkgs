{lib, fetchPypi, buildPythonPackage, numpy, pyparsing}:

buildPythonPackage rec{
  pname = "periodictable";
  version = "1.5.0";

  propagatedBuildInputs = [numpy pyparsing];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cjk6aqcz41nxm4fpriz01vqdafd6g57cjk0wh1iklk5cx6c085h";
  };

  meta = {
    homepage = http://www.reflectometry.org/danse/software.html;
    description = "an extensible periodic table of the elements prepopulated with data important to neutron and x-ray scattering experiments";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
