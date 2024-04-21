{ lib
, fetchPypi
, buildPythonPackage
, cython_3
}:

buildPythonPackage rec {
  pname = "memory-allocator";
  version = "0.1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "memory_allocator";
    hash = "sha256-1gkhawMDGWfitFqASxL/kClXj07AGf3kLPau1soJ7+Q=";
  };

  propagatedBuildInputs = [ cython_3 ];

  pythonImportsCheck = [ "memory_allocator" ];

  meta = with lib; {
    description = "An extension class to allocate memory easily with cython";
    homepage = "https://github.com/sagemath/memory_allocator/";
    maintainers = teams.sage.members;
    license = licenses.lgpl3Plus;
  };
}
