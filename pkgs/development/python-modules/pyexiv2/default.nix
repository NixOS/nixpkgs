{ stdenv, fetchurl, python, exiv2, scons, boost }:

let version = "0.3.0"; in

stdenv.mkDerivation {
  name = "pyexiv2-${version}";
  
  src = fetchurl {
    url = "http://launchpad.net/pyexiv2/0.3.x/0.3/+download/pyexiv2-0.3.0.tar.bz2";
    sha256 = "1y7r2z0ja166cx8fmykq7gaif02drknqqbxaf18fhv9nmgz4jrg9";
  };

  buildPhase = ''
    sed -i -e "s@env = Environment()@env = Environment( ENV = os.environ )@" src/SConscript
    scons
  '';
  installPhase = ''
    sed -i -e "s@    python_lib_path = get_python_lib(plat_specific=True)@    python_lib_path = \'/lib/python2.7/site-packages\'@" src/SConscript
    scons install DESTDIR=$out
  '';

  buildInputs = [ python exiv2 scons boost ];
}
