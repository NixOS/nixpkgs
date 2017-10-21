{ stdenv, fetchPypi, buildPythonPackage, pytest, pytestcov, tox }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "distro";
  version = "1.0.4";

  buildInputs = [ pytest pytestcov tox];

  checkPhase = ''
    touch tox.ini
    tox
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b000b0d637bb0cbd130a7a4835681e6993e309a85564dfea9d884825fe46954";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/nir0s/distro;
    description = "Linux Distribution - a Linux OS platform information API.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nand0p ];
  };
}
