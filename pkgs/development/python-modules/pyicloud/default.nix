{ lib
, buildPythonPackage
, fetchPypi
, requests
, keyring
, keyrings-alt
, click
, six
, tzlocal
, certifi
, bitstring
, unittest2
}:

buildPythonPackage rec {
  pname = "pyicloud";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "580b52e95f67a41ed86c56a514aa2b362f53fbaf23f16c69fb24e0d19fd373ee";
  };

  propagatedBuildInputs = [
    requests
    keyring
    keyrings-alt
    click
    six
    tzlocal
    certifi
    bitstring
  ];

  checkInputs = [ unittest2 ];

  postPatch = ''
    sed -i \
      -e 's!click>=6.0,<7.0!click!' \
      -e 's!keyring>=8.0,<9.0!keyring!' \
      -e 's!keyrings.alt>=1.0,<2.0!keyrings.alt!' \
      requirements.txt
  '';

  meta = with lib; {
    description = "PyiCloud is a module which allows pythonistas to interact with iCloud webservices";
    homepage = https://github.com/picklepete/pyicloud;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
