{
  lib,
  buildPythonPackage,
  fetchurl,
  python,
}:

buildPythonPackage rec {
  pname = "pycxx";
  version = "7.1.4";
  format = "setuptools";

  src = fetchurl {
    url = "mirror://sourceforge/cxx/CXX/PyCXX%20V${version}/pycxx-${version}.tar.gz";
    sha256 = "MUMU+/qsm92WENYFxfjQsSuR8/nE/asYG8HgIbaAaz0=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postInstall = ''
    mkdir -p $dev/include
    mv $out/include/${python.libPrefix}*/CXX/ $dev/include/CXX/
    mv $out/CXX $dev/src
    sed -i "s|Src|$dev/src|" $dev/src/cxxextensions.c $dev/src/cxxsupport.cxx
  '';

  meta = with lib; {
    description = "set of classes to help create extensions of Python in the C++ language";
    homepage = "https://sourceforge.net/projects/cxx/";
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.all;
  };
}
