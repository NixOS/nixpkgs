{ lib
, fetchPypi
, buildPythonPackage
, cython
}:

buildPythonPackage rec {
  pname = "memory-allocator";
  version = "0.1.2";

  src = fetchPypi {
    inherit version;
    pname = "memory_allocator";
    sha256 = "ddf42a2dcc678062f30c63c868335204d46a4ecdf4db0dc43ed4529f1d0ffab9";
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
