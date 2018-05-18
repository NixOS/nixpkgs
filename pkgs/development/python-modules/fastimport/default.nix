{ stdenv, buildPythonPackage, python, fetchPypi}:

buildPythonPackage rec {
  pname = "fastimport";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
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
