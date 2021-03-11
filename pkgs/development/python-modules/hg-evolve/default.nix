{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "hg-evolve";
  version = "10.2.0.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "391aa877a61ed04c58b8d82d465b3771f632bb9b19f22cbf18f0e5a1f42f8d4e";
  };

  doCheck = false;

  meta = with lib; {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with maintainers; [ xavierzwirtz ];
    license = licenses.gpl2Plus;
  };
}
