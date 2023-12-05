{ lib
, fetchPypi
, buildPythonPackage
, cython
}:

buildPythonPackage rec {
  pname = "memory-allocator";
  version = "0.1.3";

  src = fetchPypi {
    inherit version;
    pname = "memory_allocator";
    hash = "sha256-E4BcKuHAG3SJ+rXo6sk2FmK08sAkEuNlLuzkj/aVMWI=";
  };

  propagatedBuildInputs = [ cython ];

  pythonImportsCheck = [ "memory_allocator" ];

  meta = with lib; {
    description = "An extension class to allocate memory easily with cython";
    homepage = "https://github.com/sagemath/memory_allocator/";
    maintainers = teams.sage.members;
    license = licenses.lgpl3Plus;
  };
}
