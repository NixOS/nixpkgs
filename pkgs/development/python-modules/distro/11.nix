{ stdenv, fetchPypi, buildPythonPackage, pytest, pytestcov, tox }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "distro";
  version = "1.1.0";

  buildInputs = [ pytest pytestcov tox];

  checkPhase = ''
    touch tox.ini
    tox
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vn1db2akw98ybnpns92qi11v94hydwp130s8753k6ikby95883j";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/nir0s/distro;
    description = "Linux Distribution - a Linux OS platform information API.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nand0p ];
  };
}
