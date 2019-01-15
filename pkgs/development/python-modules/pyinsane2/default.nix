{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, pillow
, pkgs
}:

buildPythonPackage rec {
  pname = "pyinsane2";
  version = "2.0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d519531d552e4512776225eb400a6a4a9bfc83a08918ec7fea19cb2fa7ec4ee";
  };

  # This is needed by setup.py regardless of whether tests are enabled.
  buildInputs = [ nose ];
  propagatedBuildInputs = [ pillow ];

  postPatch = ''
    # pyinsane2 forks itself, so we need to re-inject the PYTHONPATH.
    sed -i -e '/os.putenv.*PYINSANE_DAEMON/ {
      a \        os.putenv("PYTHONPATH", ":".join(sys.path))
    }' pyinsane2/sane/abstract_proc.py

    sed -i -e 's,"libsane.so.1","${pkgs.sane-backends}/lib/libsane.so",' \
      pyinsane2/sane/rawapi.py
  '';

  # Tests require a scanner to be physically connected, so let's just do a
  # quick check whether initialization works.
  checkPhase = ''
    python -c 'import pyinsane2; pyinsane2.init()'
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/jflesch/pyinsane";
    description = "Access and use image scanners";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };

}
