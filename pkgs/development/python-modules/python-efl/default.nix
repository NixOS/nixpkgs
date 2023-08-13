{ lib
, fetchurl
, buildPythonPackage
, pkg-config
, python
, dbus-python
, packaging
, enlightenment
, directoryListingUpdater
}:

# Should be bumped along with EFL!

buildPythonPackage rec {
  pname = "python-efl";
  version = "1.26.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/bindings/python/${pname}-${version}.tar.xz";
    sha256 = "0dj6f24n33hkpy0bkdclnzpxhvs8vpaxqaf7hkw0di19pjwrq25h";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ enlightenment.efl ];

  propagatedBuildInputs = [ dbus-python packaging ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE="$(pkg-config --cflags efl evas) $NIX_CFLAGS_COMPILE"
  '';

  preBuild = ''
    ${python.pythonForBuild.interpreter} setup.py build_ext
  '';

  installPhase = ''
    ${python.pythonForBuild.interpreter} setup.py install --prefix=$out --single-version-externally-managed
  '';

  doCheck = false;

  passthru.updateScript = directoryListingUpdater { };

  meta = with lib; {
    description = "Python bindings for Enlightenment Foundation Libraries";
    homepage = "https://github.com/DaveMDS/python-efl";
    platforms = platforms.linux;
    license = with licenses; [ gpl3 lgpl3 ];
    maintainers = with maintainers; [ matejc ftrvxmtrx ] ++ teams.enlightenment.members;
    # The generated files in the tarball aren't compatible with python 3.11
    # See https://sourceforge.net/p/enlightenment/mailman/message/37794291/
    broken = python.pythonAtLeast "3.11";
  };
}
