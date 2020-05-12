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
, future
}:

buildPythonPackage rec {
  pname = "pyicloud";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c8sdlqcmpajcpf6jfpi6amncibm9c3zrl1860r0vfimps50m34h";
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
    future
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
    homepage = "https://github.com/picklepete/pyicloud";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
