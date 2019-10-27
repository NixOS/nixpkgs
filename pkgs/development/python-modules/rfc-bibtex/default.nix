{ stdenv, buildPythonApplication, fetchPypi, isPy3k }:

buildPythonApplication rec {
  pname = "rfc-bibtex";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p8xjgq4rig1jgqy5jqh34mbifxgxsyyxh8sizwz2wyixf8by8lq";
  };

  disabled = !isPy3k;

  meta = with stdenv.lib; {
    homepage = ttps://github.com/iluxonchik/rfc-bibtex/;
    description = "Generate Bibtex entries for IETF RFCs and Internet-Drafts";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}
