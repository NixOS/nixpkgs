{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "hg-evolve";
  version = "10.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbc46f7381eb4bb0435eb3e2d2336ef77e9d5b3fabbb6b2c38cabe7d9bb2bc0f";
  };

  doCheck = false;

  meta = with lib; {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with maintainers; [ xavierzwirtz ];
    license = licenses.gpl2Plus;
  };
}
