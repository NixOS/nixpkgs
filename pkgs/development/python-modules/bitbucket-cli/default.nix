{ stdenv, buildPythonPackage, fetchPypi, isPy3k, requests }:

buildPythonPackage rec {
  pname = "bitbucket-cli";
  version = "0.5.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xmn73x6jirnwfwcdy380ncmkai9f9dhmld6zin01ypbqwgf50fq";
  };

  propagatedBuildInputs = [ requests ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Bitbucket command line interface";
    homepage = https://bitbucket.org/zhemao/bitbucket-cli;
    maintainers = with maintainers; [ refnil ];
    license = licenses.bsd2;
  };
}
