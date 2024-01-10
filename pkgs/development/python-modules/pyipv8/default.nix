{ lib
, fetchPypi
, buildPythonPackage
, cryptography
, libnacl
, aiohttp
, aiohttp-apispec
, pyopenssl
, pyasn1
, marshmallow
, typing-extensions
, packaging
, apispec
}:

buildPythonPackage rec {
  pname = "pyipv8";
  version = "2.12.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FXvMykUko3v0GmAZYUt5esBuTbxqpjOL4YxrRfE3u5o=";
  };

  propagatedBuildInputs = [
    cryptography
    libnacl
    aiohttp
    aiohttp-apispec
    pyopenssl
    pyasn1
    marshmallow
    typing-extensions
    packaging
    apispec
  ];

  doCheck = false;

  meta = with lib; {
    description = "Python implementation of Tribler's IPv8 p2p-networking layer";
    homepage = "https://github.com/Tribler/py-ipv8";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      mkg20001
    ];
  };
}
