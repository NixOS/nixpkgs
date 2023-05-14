{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "asterisk-mbox";
  version = "0.5.0";

  src = fetchPypi {
    pname = "asterisk_mbox";
    inherit version;
    sha256 = "0624f9ab85ce9c4d43655f8653e8539fa10c81b60fd7b94b1a15dce306c20888";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "asterisk_mbox" ];

  meta = with lib; {
    description = "The client side of a client/server to interact with Asterisk voicemail mailboxes";
    homepage = "https://github.com/PhracturedBlue/asterisk_mbox";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
