{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, pytz
, gflags
, dateutil
, mox
, python
}:

buildPythonPackage rec {
  pname = "google-apputils";
  version = "0.4.2";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0afw0gxmh0yw5g7xsmw49gs8bbp0zyhbh6fr1b0h48f3a439v5a7";
  };

  preConfigure = ''
    sed -i '/ez_setup/d' setup.py
  '';

  propagatedBuildInputs = [ pytz gflags dateutil mox ];

  checkPhase = ''
    ${python.executable} setup.py google_test
  '';

  # ERROR:root:Trying to access flag test_tmpdir before flags were parsed.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Google Application Utilities for Python";
    homepage = "https://github.com/google/google-apputils";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
