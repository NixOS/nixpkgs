{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "hg-evolve";
  version = "10.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d7f73fc1c357134ae9b4a3ed2d844ab8e75a4ca1303679a9e150e87617e7bc7";
  };

  doCheck = false;

  meta = with lib; {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with maintainers; [ xavierzwirtz ];
    license = licenses.gpl2Plus;
  };
}
