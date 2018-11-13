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
}
