{ stdenv, buildPythonPackage, fetchPypi, certifi, six }:

buildPythonPackage rec {
  pname = "pylast";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e883f13b70c3879fc821bbee1accf27ea4e68898f4462cbbe358f615adcbbfb";
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
