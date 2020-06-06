{ stdenv, fetchPypi, buildPythonPackage, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "distro";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92";
  };

  # TODO: Enable more tests on NixOS (20 out of 173 are failing, 10 due to the
  # missing lsb_release binary):
  patches = [ ./nixos.patch ];

  checkInputs = [ pytest pytestcov ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/nir0s/distro";
    description = "Linux Distribution - a Linux OS platform information API.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nand0p ];
  };
}
