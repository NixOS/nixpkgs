{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "nose-pattern-exclude";
  version = "0.1.3";

  propagatedBuildInputs = [ nose ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0apzxx8lavsdlxlpaxqw1snx5p7q8v5dfbip6v32f9pj2vyain1i";
  };

  # There are no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Exclude specific files and directories from nosetests runs";
    homepage = https://github.com/jakubroztocil/nose-pattern-exclude;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
