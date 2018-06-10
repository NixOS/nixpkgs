{ stdenv, fetchPypi, buildPythonPackage, pytest, pytestcov, tox }:

buildPythonPackage rec {
  pname = "distro";
  version = "1.2.0";

  buildInputs = [ pytest pytestcov tox];

  checkPhase = ''
    touch tox.ini
    tox
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "d94370e43b676ac44fbe1ab68ca903a6147eaba3a9e8eff85b2c05556a455b76";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/nir0s/distro;
    description = "Linux Distribution - a Linux OS platform information API.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nand0p ];
  };
}
