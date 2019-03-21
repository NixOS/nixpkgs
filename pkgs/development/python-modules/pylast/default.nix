{ stdenv, buildPythonPackage, fetchPypi, isPy3k, certifi, six }:

buildPythonPackage rec {
  pname = "pylast";
  version = "3.0.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "24051c52011ff18bdeaee9df084ecc90da6c627da86f3cdcfec4af2928e9bc56";
  };

  propagatedBuildInputs = [ certifi six ];

  # tests require last.fm credentials
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/pylast/pylast;
    description = "A python interface to last.fm (and compatibles)";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
