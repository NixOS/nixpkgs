{ stdenv, fetchPypi, buildPythonPackage, pytest, pytestcov, tox }:

buildPythonPackage rec {
  pname = "distro";
  version = "1.4.0";

  checkInputs = [ pytest pytestcov ];

  checkPhase = ''
    py.test
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "362dde65d846d23baee4b5c058c8586f219b5a54be1cf5fc6ff55c4578392f57";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/nir0s/distro;
    description = "Linux Distribution - a Linux OS platform information API.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nand0p ];
    # Many failing tests
    broken = true;
  };
}
