{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "distro";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09441261dd3c8b2gv15vhw1cryzg60lmgpkk07v6hpwwkyhfbxc3";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Some distributions can't be tested
    "test_debian8_release"
    "test_linuxmint17_lsb_release"
    "test_mageia5_release"
    "test_mandriva2011_release"
    "test_manjaro1512_lsb_release"
    "test_manjaro1512_lsb_release"
    "test_manjaro1512_release"
    "test_sles12_release"
    "test_trailingblanks_lsb_release"
    "test_trailingblanks_lsb_release"
    "test_ubuntu14nomodules_lsb_release"
    "test_ubuntu14nomodules_lsb_release"
    "test_ubuntu14normal_lsb_release"
    "test_ubuntu14normal_lsb_release"
  ];

  pythonImportsCheck = [ "distro" ];

  meta = with lib; {
    description = "Python module for getting information about the OS distribution it runs on";
    homepage = "https://github.com/nir0s/distro";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
