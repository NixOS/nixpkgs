{ lib, buildPythonPackage, fetchPypi, fetchpatch }:

buildPythonPackage rec {
  pname = "pybind11";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0923ngd2cvck3lhl7584y08n36pm6zqihfm1s69sbdc11xg936hr";
  };

  patches = [
    (fetchpatch {
      url = https://github.com/pybind/pybind11/commit/44a40dd61e5178985cfb1150cf05e6bfcec73042.patch;
      sha256 = "047nzyfsihswdva96hwchnp4gj2mlbiqvmkdnhxrfi9sji8x31ka";
    })
  ];

  # Current PyPi version does not include test suite
  doCheck = false;

  meta = {
    homepage = https://github.com/pybind/pybind11;
    description = "Seamless operability between C++11 and Python";
    longDescription = ''
      Pybind11 is a lightweight header-only library that exposes
      C++ types in Python and vice versa, mainly to create Python
      bindings of existing C++ code.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.yuriaisaka ];
  };
}
