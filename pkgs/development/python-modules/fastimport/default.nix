{ lib, buildPythonPackage, python, fetchPypi}:

buildPythonPackage rec {
  pname = "fastimport";
  version = "0.9.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "486135a39edb85808fdbbe2c8009197978800a4544fca56cc2074df32e1304f3";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    homepage = "https://launchpad.net/python-fastimport";
    description = "VCS fastimport/fastexport parser";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl2Plus;
  };
}
