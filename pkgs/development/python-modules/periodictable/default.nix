{lib, fetchPypi, buildPythonPackage, numpy, pyparsing}:

buildPythonPackage rec{
  pname = "periodictable";
  version = "1.5.1";

  propagatedBuildInputs = [numpy pyparsing];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qd7rjhlnb2xxi7rhpidh9pabg2m4rq6zhdcsyiymni8mgjm8dfg";
  };

  meta = {
    homepage = http://www.reflectometry.org/danse/software.html;
    description = "an extensible periodic table of the elements prepopulated with data important to neutron and x-ray scattering experiments";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
