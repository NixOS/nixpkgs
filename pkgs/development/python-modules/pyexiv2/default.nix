{ stdenv, buildPythonPackage, fetchurl, python, exiv2, scons, boost }:

buildPythonPackage rec {
  pname = "pyexiv2";
  version = "0.3.2";
  format = "other";

  src = fetchurl {
    url = "https://launchpad.net/pyexiv2/0.3.x/0.3.2/+download/${pname}-${version}.tar.bz2";
    sha256 = "09r1ga6kj5cnmrldpkqzvdhh7xi7aad9g4fbcr1gawgsd9y13g0a";
  };

  preBuild = ''
    sed -i -e "s@env = Environment()@env = Environment( ENV = os.environ )@" src/SConscript
  '';

  preInstall = ''
    sed -i -e "s@    python_lib_path = get_python_lib(plat_specific=True)@    python_lib_path = \'/lib/python2.7/site-packages\'@" src/SConscript
  '';

  buildInputs = [ python exiv2 scons boost ];

  meta = {
    platforms = stdenv.lib.platforms.linux;
    # Likely needs an older boost which does not have `boost_pythonXY` but `boost_python`.
    broken = true; # 2018-06-23
  };
}
