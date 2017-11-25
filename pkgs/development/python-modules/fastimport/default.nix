{ stdenv, buildPythonPackage, python, fetchurl }:

buildPythonPackage rec {
  pname = "fastimport";
  version = "0.9.6";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/f/fastimport/${name}.tar.gz";
    sha256 = "1aqjsin4rmqm7ln4j0p73fzxifws6c6ikgyhav7r137m2ixsxl43";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/python-fastimport;
    description = "VCS fastimport/fastexport parser";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl2Plus;
  };
}
