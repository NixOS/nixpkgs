{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pylzma";
  version = "0.5.0";
  format = "setuptools";

  # This vendors an old LZMA SDK
  # After some discussion, it seemed most reasonable to keep it that way
  # xz, and uefi-firmware-parser also does this
  src = fetchPypi {
    inherit pname version;
    sha256 = "074anvhyjgsv2iby2ql1ixfvjgmhnvcwjbdz8gk70xzkzcm1fx5q";
  };

  pythonImportsCheck = [ "pylzma" ];

  meta = with lib; {
    homepage = "https://www.joachim-bauch.de/projects/pylzma/";
    description = "Platform independent python bindings for the LZMA compression library";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
