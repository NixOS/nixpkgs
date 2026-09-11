{
  lib,
  buildPythonPackage,
  fetchurl,
  setuptools,
  python,
}:

buildPythonPackage rec {
  pname = "pycxx";
  version = "7.1.8";
  pyproject = true;

  src = fetchurl {
    url = "mirror://sourceforge/cxx/CXX/PyCXX%20V${version}/pycxx-${version}.tar.gz";
    hash = "sha256-S5Hh4RQcI/vVA532NcS7bnVjIWhUj1a4POF3GTwMmMY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  build-system = [ setuptools ];

  postInstall = ''
    mkdir -p $dev/include
    mv $out/include/${python.libPrefix}*/* $dev/include
    ln -s $dev/include/cxx $dev/include/CXX # pysvn compat
    mv $out/CXX $dev/src
    sed -i "s|Src|$dev/src|" $dev/src/cxxextensions.c $dev/src/cxxsupport.cxx
  '';

  meta = {
    description = "Set of classes to help create extensions of Python in the C++ language";
    homepage = "https://sourceforge.net/projects/cxx/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
