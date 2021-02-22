{ lib
, fetchurl
, buildPythonPackage
, pkg-config
, python
, dbus-python
, enlightenment
}:

# Should be bumped along with EFL!

buildPythonPackage rec {
  pname = "python-efl";
  version = "1.25.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/bindings/python/${pname}-${version}.tar.xz";
    sha256 = "0bk161xwlz4dlv56r68xwkm8snzfifaxd1j7w2wcyyk4fgvnvq4r";
  };

  nativeBuildInputs = [ pkg-config ];

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

  meta = with lib; {
    description = "Python bindings for EFL and Elementary";
    homepage = "https://phab.enlightenment.org/w/projects/python_bindings_for_efl/";
    platforms = platforms.linux;
    license = with licenses; [ gpl3 lgpl3 ];
    maintainers = with maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
