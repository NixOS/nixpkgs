{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, python
}:

buildPythonPackage rec {
  pname = "lit";
  version = "17.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-36mvm1X8RQmla+e/I0bwedf0okLVg7ny4LB4/Qq64xs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  passthru = {
    inherit python;
  };

  # Non-standard test suite. Needs custom checkPhase.
  # Needs LLVM's `FileCheck` and `not`: `$out/bin/lit tests`
  # There should be `llvmPackages.lit` since older LLVM versions may
  # have the possibility of not correctly interfacing with newer lit versions
  doCheck = false;

  meta = {
    description = "Portable tool for executing LLVM and Clang style test suites";
    homepage = "http://llvm.org/docs/CommandGuide/lit.html";
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ dtzWill ];
  };
}
