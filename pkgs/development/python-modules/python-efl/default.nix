{ stdenv, fetchurl, buildPythonPackage, pkgconfig, python, enlightenment }:

# Should be bumped along with EFL!

buildPythonPackage rec {
  name = "python-efl-${version}";
  version = "1.21.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/bindings/python/${name}.tar.xz";
    sha256 = "08x2cv8hnf004c3711250wrax21ffj5y8951pvk77h98als4pq47";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ enlightenment.efl ];

  propagatedBuildInputs = [ python.pkgs.dbus-python ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$(pkg-config --cflags efl) -I${python.pkgs.dbus-python}/include/dbus-1.0 $NIX_CFLAGS_COMPILE"
  '';
  
  preBuild = "${python.interpreter} setup.py build_ext";

  installPhase= "${python.interpreter} setup.py install --prefix=$out";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python bindings for EFL and Elementary";
    homepage = https://phab.enlightenment.org/w/projects/python_bindings_for_efl/;
    platforms = platforms.linux;
    license = with licenses; [ gpl3 lgpl3 ];
    maintainers = with maintainers; [ matejc tstrobel ftrvxmtrx ];
  };
}
