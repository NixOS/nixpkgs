{ stdenv, buildPythonPackage, python, fetchPypi}:

buildPythonPackage rec {
  pname = "fastimport";
  version = "0.9.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2f2e8eb97000256e1aab83d2a0a053fc7b93c3aa4f7e9b971a5703dfc5963b9";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    homepage = "https://launchpad.net/python-fastimport";
    description = "VCS fastimport/fastexport parser";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl2Plus;
  };
}
