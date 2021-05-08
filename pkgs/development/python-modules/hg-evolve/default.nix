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
    sha256 = "03xwnadpvgna70n6pfxb7xdrszppdqrx5qmkbr1v0jzbh5rnzi6b";
  };

  doCheck = false;

  meta = with lib; {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with maintainers; [ xavierzwirtz lukegb ];
    license = licenses.gpl2Plus;
  };
}
