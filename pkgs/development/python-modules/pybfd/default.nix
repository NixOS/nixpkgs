{ lib, buildPythonPackage, isPyPy, isPy3k, fetchurl, gdb, binutils }:

buildPythonPackage rec {
  name = "pybfd-0.1.1";

  disabled = isPyPy || isPy3k;

  src = fetchurl {
    url = "mirror://pypi/p/pybfd/${name}.tar.gz";
    sha256 = "d99b32ad077e704ddddc0b488c83cae851c14919e5cbc51715d00464a1932df4";
  };

  preConfigure = ''
    substituteInPlace setup.py \
      --replace '"/usr/include"' '"${gdb}/include"' \
      --replace '"/usr/lib"' '"${binutils.lib}/lib"'
  '';

  meta = {
    homepage = https://github.com/Groundworkstech/pybfd;
    description = "A Python interface to the GNU Binary File Descriptor (BFD) library";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
