{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyxdg";
  version = "0.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://freedesktop.org/wiki/Software/pyxdg;
    description = "Contains implementations of freedesktop.org standards";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
