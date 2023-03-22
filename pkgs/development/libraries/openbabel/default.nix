{ stdenv, lib, fetchFromGitHub, cmake, zlib, libxml2, eigen, python, cairo, pcre, pkg-config, swig, rapidjson }:

stdenv.mkDerivation rec {
  pname = "openbabel";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "openbabel";
    repo = "openbabel";
    rev = "openbabel-${lib.replaceStrings ["."] ["-"] version}";
    sha256 = "sha256-wQpgdfCyBAoh4pmj9j7wPTlMtraJ62w/EShxi/olVMY=";
  };

  postPatch = ''
    sed '1i#include <ctime>' -i include/openbabel/obutil.h # gcc12
  '';

  buildInputs = [ zlib libxml2 eigen python cairo pcre swig rapidjson ];

  nativeBuildInputs = [ cmake pkg-config ];

  pythonMajorMinor = "${python.sourceVersion.major}.${python.sourceVersion.minor}";

  cmakeFlags = [
    "-DRUN_SWIG=ON"
    "-DPYTHON_BINDINGS=ON"
  ];

  postFixup = ''
    cat <<EOF > $out/lib/python$pythonMajorMinor/site-packages/setup.py
    from distutils.core import setup

    setup(
        name = 'pyopenbabel',
        version = '${version}',
        packages = ['openbabel'],
        package_data = {'openbabel' : ['_openbabel.so']}
    )
    EOF
  '';

  meta = with lib; {
    description = "A toolbox designed to speak the many languages of chemical data";
    homepage = "http://openbabel.org";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ danielbarter ];
  };
}
