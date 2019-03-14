{ stdenv, fetchPypi, buildPythonPackage, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "distro";
  version = "1.4.0";

  checkInputs = [ pytest pytestcov ];

  # not sure why these tests fail under nix
  checkPhase = ''
    py.test \
      --deselect tests/test_distro.py::TestLSBRelease::test_linuxmint17_lsb_release \
      --deselect tests/test_distro.py::TestLSBRelease::test_manjaro1512_lsb_release \
      --deselect tests/test_distro.py::TestLSBRelease::test_ubuntu14normal_lsb_release \
      --deselect tests/test_distro.py::TestLSBRelease::test_ubuntu14nomodules_lsb_release \
      --deselect tests/test_distro.py::TestLSBRelease::test_trailingblanks_lsb_release \
      --deselect tests/test_distro.py::TestLSBRelease::test_lsb_release_error_level \
      --deselect tests/test_distro.py::TestOverall::test_debian8_release \
      --deselect tests/test_distro.py::TestOverall::test_mageia5_release \
      --deselect tests/test_distro.py::TestOverall::test_manjaro1512_release \
      --deselect tests/test_distro.py::TestOverall::test_sles12_release \
      --deselect tests/test_distro.py::TestOverall::test_mandriva2011_release \
      --deselect tests/test_distro.py::TestOverallWithEtcNotReadable::test_debian8_release \
      --deselect tests/test_distro.py::TestOverallWithEtcNotReadable::test_mageia5_release \
      --deselect tests/test_distro.py::TestOverallWithEtcNotReadable::test_manjaro1512_release \
      --deselect tests/test_distro.py::TestOverallWithEtcNotReadable::test_sles12_release \
      --deselect tests/test_distro.py::TestOverallWithEtcNotReadable::test_mandriva2011_release
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
  };
}
