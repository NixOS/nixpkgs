{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  version = "1.4";
  pname = "progress";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e2f9da88ed8236a76fffbee3ceefd259589cf42dfbc2cec2877102189fae58a";
  };

  # tests not packaged with pypi release
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} test_progress.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/verigak/progress/;
    description = "Easy to use progress bars";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
