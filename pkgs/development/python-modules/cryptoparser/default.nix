{ lib
, buildPythonPackage
, fetchPypi
, attrs
, six
, asn1crypto
, python-dateutil
}:

buildPythonPackage rec {
  pname = "cryptoparser";
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eLQNqeCUnjcxWbazhWHtqJJgvPUMH42fboU5y2ZMy44=";
  };

  propagatedBuildInputs = [
    attrs
    six
    asn1crypto
    python-dateutil
  ];

  pythonImportsCheck = [ "cryptoparser" ];

  meta = with lib; {
    description = "Fast and flexible security protocol parser and generator";
    homepage = "https://gitlab.com/coroner/cryptoparser";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kranzes ];
  };
}
