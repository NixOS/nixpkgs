{ stdenv, fetchPypi, buildPythonPackage, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "distro";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mrg75w4ap7mdzyga75yaid9n8bgb345ih5mwjp3plj6v1jxwb9n";
  };

  # TODO: Enable more tests on NixOS (20 out of 173 are failing, 10 due to the
  # missing lsb_release binary):
  patches = [ ./nixos.patch ];

  checkInputs = [ pytest pytestcov ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/nir0s/distro;
    description = "Linux Distribution - a Linux OS platform information API.";
    license = licenses.asl20;
    maintainers = with maintainers; [ nand0p ];
  };
}
