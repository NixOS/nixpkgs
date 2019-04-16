{ lib
, buildPythonPackage
, fetchPypi
, taglib
, cython
, pytest
, glibcLocales
}:

buildPythonPackage rec {
  pname   = "pytaglib";
  version = "1.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8aec64bc146a9f72778a0d2d1f3448f58be6ebea68f64b0ff88ea8e0f4dc5d8f";
  };

  buildInputs = [ taglib cython ];

  checkInputs = [ pytest glibcLocales ];

  checkPhase = ''
    LC_ALL=en_US.utf-8 pytest .
  '';

  meta = {
    homepage = https://github.com/supermihi/pytaglib;
    description = "Python 2.x/3.x bindings for the Taglib audio metadata library";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.mrkkrp ];
  };
}
