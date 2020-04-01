{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "hg-evolve";
  version = "9.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08bjrgxv8zrrz5xxydzkjl4a8cw3g62nmzfnvdzxxcrf1c96qw76";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with maintainers; [ xavierzwirtz ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
