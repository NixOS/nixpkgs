{ stdenv, lib, fetchFromGitHub, cmake, perl, zlib, libxml2, eigen, python, cairo, pcre, pkg-config, swig, rapidjson }:

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

  buildInputs = [ perl zlib libxml2 eigen python cairo pcre swig rapidjson ];

  nativeBuildInputs = [ cmake pkg-config ];

  pythonMajorMinor = "${python.sourceVersion.major}.${python.sourceVersion.minor}";

  cmakeFlags = [
    "-DRUN_SWIG=ON"
    "-DPYTHON_BINDINGS=ON"
  ];

  # Setuptools only accepts PEP 440 version strings. The "unstable" identifier
  # can not be used. Instead we pretend to be the 3.2 beta release.
  postFixup = ''
    cat <<EOF > $out/lib/python$pythonMajorMinor/site-packages/setup.py
    from distutils.core import setup

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
