{ lib
, buildPythonPackage
, fetchPypi
, chardet
, six
}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.40";

  src = fetchPypi {
    inherit pname version;
    sha256 = "385dfb965eca75164d256486c7cf9bae772d24144249fd18b9d15d3cffb70eea";
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
