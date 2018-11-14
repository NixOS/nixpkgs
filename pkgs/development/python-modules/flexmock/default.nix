{ lib
, fetchPypi
, buildPythonPackage
, nose
, pytest
}:

buildPythonPackage rec {
  pname = "flexmock";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe95c8727f4db73dc8f2f7b4548bffe7992440a965fefd60da291abda5352c2b";
  };

  buildInputs = [ nose pytest ];

  meta = with lib; {
    homepage = https://flexmock.readthedocs.io/en/latest/;
    description = "flexmock is a testing library for Python.";
    license = licenses.bsd2;
  };
}
