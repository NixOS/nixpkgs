{ stdenv, python3Packages, withTwitter ? false}:

python3Packages.buildPythonApplication rec {
  pname = "mailman-rss";
  version = "0.2.4";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1brrik70jyagxa9l0cfmlxvqpilwj1q655bphxnvjxyganxf4c00";
  };

  propagatedBuildInputs = with python3Packages; [ dateutil future requests beautifulsoup4 ]
    ++ stdenv.lib.optional withTwitter python3Packages.twitter
  ;

  # No tests in Pypi Tarball
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mailman archive -> rss converter";
    homepage = https://github.com/kyamagu/mailman-rss;
    license = licenses.mit;
    maintainers = with maintainers; [ samueldr ];
  };
}
