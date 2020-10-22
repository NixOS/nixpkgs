{ lib
, buildPythonPackage
, fetchPypi
, pytestrunner
, pytest
, six
}:

buildPythonPackage rec {
  pname = "ndjson";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mp556r9ddw9wvj430zjbxk6sy3wq1ag39ydfb8m7jxidg5ld5xz";
  };

  checkInputs = [ pytestrunner pytest six ];

  meta = with lib; {
    homepage = "https://github.com/rhgrant10/ndjson";
    description = "JsonDecoder for ndjson";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ nbke ];
  };
}
