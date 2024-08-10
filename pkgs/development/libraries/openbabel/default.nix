{ stdenv
, lib
, fetchFromGitHub
, cmake
, perl
, zlib
, libxml2
, eigen
, python
, cairo
, pcre
, pkg-config
, swig
, rapidjson
, boost
, maeparser
, coordgenlibs
}:

stdenv.mkDerivation rec {
  pname = "openbabel";
  version = "unstable-06-12-23";

  src = fetchFromGitHub {
    owner = "openbabel";
    repo = pname;
    rev = "32cf131444c1555c749b356dab44fb9fe275271f";
    hash = "sha256-V0wrZVrojCZ9Knc5H6cPzPoYWVosRZ6Sn4PX+UFEfHY=";
  };

  postPatch = ''
    sed '1i#include <ctime>' -i include/openbabel/obutil.h # gcc12
  '';

  buildInputs = [ perl zlib libxml2 eigen python cairo pcre swig rapidjson boost maeparser coordgenlibs ];

  nativeBuildInputs = [ cmake pkg-config ];

  preConfigure = ''
    cmakeFlagsArray+=(
      "-DRUN_SWIG=ON"
      "-DPYTHON_BINDINGS=ON"
      "-DPYTHON_INSTDIR=$out/${python.sitePackages}"
    )
  '';

  # Setuptools only accepts PEP 440 version strings. The "unstable" identifier
  # can not be used. Instead we pretend to be the 3.2 beta release.
  postFixup = ''
    cat << EOF > $out/${python.sitePackages}/setup.py
    from setuptools import setup

    setup(
        name = 'pyopenbabel',
        version = '3.2b1',
        packages = ['openbabel'],
        package_data = {'openbabel' : ['_openbabel.so']}
    )
    EOF
  '';

  meta = with lib; {
    description = "Toolbox designed to speak the many languages of chemical data";
    homepage = "http://openbabel.org";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ danielbarter ];
  };
}
