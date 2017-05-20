{ stdenv, fetchPypi, buildPythonPackage, pytest, pytestcov, tox }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "distro";
  version = "1.0.3";

  buildInputs = [ pytest pytestcov tox];

  checkPhase = ''
    touch tox.ini
    tox
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kmjdz1kxspsmps73m2kzhxz86jj43ikx825hmgmwbx793ywv69d";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/nir0s/distro;
    description = "Linux Distribution - a Linux OS platform information API.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nand0p ];
  };
}
