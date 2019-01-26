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
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3458e64cea61a7d4189f26c601e7bfd82053f3c02c2247cb8c430847927ef18";
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
