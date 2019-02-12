{ stdenv, fetchPypi, buildPythonPackage, pytest, pytestcov, tox }:

buildPythonPackage rec {
  pname = "distro";
  version = "1.3.0";

  checkInputs = [ pytest pytestcov tox];

  checkPhase = ''
    touch tox.ini
    tox
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "224041cef9600e72d19ae41ba006e71c05c4dc802516da715d7fda55ba3d8742";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/nir0s/distro;
    description = "Linux Distribution - a Linux OS platform information API.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nand0p ];
  };
}
