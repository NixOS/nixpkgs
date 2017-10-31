{ stdenv, fetchurl, python, exiv2, scons, boost }:

stdenv.mkDerivation rec {
  pname = "pyexiv2";
  version = "0.3.2";
  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "http://launchpad.net/pyexiv2/0.3.x/0.3.2/+download/${name}.tar.bz2";
    sha256 = "09r1ga6kj5cnmrldpkqzvdhh7xi7aad9g4fbcr1gawgsd9y13g0a";
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

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
