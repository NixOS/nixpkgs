{ lib
, fetchPypi
, buildPythonPackage
, cython
}:

buildPythonPackage rec {
  pname = "memory_allocator";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UUcR71e3eAQIQpmWM+AVQxVtgHvrNjaIlHo5pURUln0=";
  };

  propagatedBuildInputs = [
    cython
  ];

  meta = with lib; {
    description = "An extension class to allocate memory easily with cython";
    homepage = "https://github.com/sagemath/memory_allocator/";
    maintainers = teams.sage.members;
    license = licenses.lgpl3Plus;
  };
}
