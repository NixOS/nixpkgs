{ stdenv, buildPythonApplication, fetchPypi, isPy3k }:

buildPythonApplication rec {
  pname = "rfc-bibtex";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "60419a2043ef37ac2438f3eae7a3207d0a4cb2dd56ab21697f874a35ee52927f";
  };

  disabled = !isPy3k;

  meta = with stdenv.lib; {
    homepage = ttps://github.com/iluxonchik/rfc-bibtex/;
    description = "Generate Bibtex entries for IETF RFCs and Internet-Drafts";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}
