{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "hg-evolve";
  version = "10.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9468b3e2721744b077413c3d4a6b321b61370d4c87b90afa40dc2b48ad877d4b";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Enables the “changeset evolution” feature of Mercurial core";
    homepage = "https://www.mercurial-scm.org/doc/evolution/";
    maintainers = with maintainers; [ xavierzwirtz ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
