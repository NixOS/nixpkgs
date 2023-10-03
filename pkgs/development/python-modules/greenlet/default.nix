{ lib
, buildPythonPackage
, fetchPypi
, objgraph
, psutil
, pytestCheckHook
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GYNOP5H0hUQq3B7kQBcexdmkhAofe9Xtl4M1RHGc4Qs=";
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
