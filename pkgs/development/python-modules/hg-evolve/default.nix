{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "hg-evolve";
  version = "10.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a386e6ee2d9a0e332a49f1cb210c4c11ba9844bcd52808270f48e688314783d8";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with maintainers; [ xavierzwirtz ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
