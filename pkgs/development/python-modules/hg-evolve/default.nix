{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "hg-evolve";
  version = "9.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jqlckibf7wwrg7syx6mzqz6zsipmsl474rfpmin6j6axh4cdpn7";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with maintainers; [ xavierzwirtz ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
