{ lib
, buildPythonPackage
, fetchPypi
, taglib
, cython
}:

buildPythonPackage rec {
  pname   = "pytaglib";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44ab26dc4b33962b8db0bb8856e7b166539c0c555bc933a6bbbc96f4ec51c7a2";
  };

  buildInputs = [ taglib cython ];

  meta = {
    homepage = https://github.com/supermihi/pytaglib;
    description = "Python 2.x/3.x bindings for the Taglib audio metadata library";
    license = lib.licenses.gpl3;
  };
}
