{ stdenv
, fetchurl
, buildPythonPackage
, pkgconfig
, python
, dbus-python
, enlightenment
}:

# Should be bumped along with EFL!

buildPythonPackage rec {
  pname = "python-efl";
  version = "1.24.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/bindings/python/${pname}-${version}.tar.xz";
    sha256 = "1vk1cdd959gia4a9qzyq56a9zw3lqf9ck66k8c9g3c631mp5cfpy";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ enlightenment.efl ];

  propagatedBuildInputs = [ dbus-python ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE="$(pkg-config --cflags efl evas) $NIX_CFLAGS_COMPILE"
  '';

  preBuild = ''
    ${python.interpreter} setup.py build_ext
  '';

  installPhase = ''
    ${python.interpreter} setup.py install --prefix=$out
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python bindings for EFL and Elementary";
    homepage = "https://phab.enlightenment.org/w/projects/python_bindings_for_efl/";
    platforms = platforms.linux;
    license = with licenses; [ gpl3 lgpl3 ];
    maintainers = with maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
