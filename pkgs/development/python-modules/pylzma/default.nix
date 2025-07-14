{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
}:

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

  patches = [
    # https://github.com/fancycode/pylzma/pull/82/
    (fetchpatch {
      url = "https://github.com/fancycode/pylzma/commit/2fe0a4ed0588fd572931da4be10ad955636afde4.patch";
      hash = "sha256-sWdMAmOPVTDnxNTjzPlqQYxqnjmRpK+OqwWF6jpXvIw=";
    })
  ];

  pythonImportsCheck = [ "pylzma" ];

  meta = with lib; {
    homepage = "https://www.joachim-bauch.de/projects/pylzma/";
    description = "Platform independent python bindings for the LZMA compression library";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
