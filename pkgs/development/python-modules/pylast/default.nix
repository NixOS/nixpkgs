{ stdenv, buildPythonPackage, fetchPypi, certifi, six }:

buildPythonPackage rec {
  pname = "pylast";
  version = "2.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e4d4962aa12d67bd357e1aa596a146b2e97afd943b5c9257e555014d13b3065";
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
