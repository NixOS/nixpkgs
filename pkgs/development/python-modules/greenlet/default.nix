{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, objgraph
, psutil
, pytestCheckHook
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "2.0.1";
  format = "setuptools";
  disabled = isPyPy; # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QuYCVkRg2g6O5ny21yNjY+5eExqhWUO2Zw5E5cLtD2c=";
  };

  nativeCheckInputs = [
    objgraph
    psutil
    pytestCheckHook
  ];

  doCheck = false; # installed tests need to be executed, not sure how to accomplish that

  meta = with lib; {
    homepage = "https://github.com/python-greenlet/greenlet";
    description = "Module for lightweight in-process concurrent programming";
    license = with licenses; [
      psfl # src/greenlet/slp_platformselect.h & files in src/greenlet/platform/ directory
      mit
    ];
  };
}
