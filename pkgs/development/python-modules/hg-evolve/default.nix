{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "hg-evolve";
  version = "9.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d3gd8k0p6n2flcf7kny1zjvrbbrwbbq4lq82ah6gvnbvllxm4hj";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with maintainers; [ xavierzwirtz ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
