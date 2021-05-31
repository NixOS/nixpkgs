{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "hg-evolve";
  version = "10.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ba819732409d39ddd4ff2fc507dc921408bf30535d2d78313637b29eeac98860";
  };

  doCheck = false;

  meta = with lib; {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with maintainers; [ xavierzwirtz lukegb ];
    license = licenses.gpl2Plus;
  };
}
