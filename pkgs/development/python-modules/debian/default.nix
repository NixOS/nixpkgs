{ lib
, buildPythonPackage
, fetchPypi
, chardet
, six
}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.42";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a794f4c4ee2318ae7260c2e32dac252b833bdaf6686efc2a1afbc6ecf3f0931f";
  };

  propagatedBuildInputs = [ chardet six ];

  # No tests in archive
  doCheck = false;

  pythonImportsCheck = [ "debian" ];

  meta = with lib; {
    description = "Debian package related modules";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
  };
}
