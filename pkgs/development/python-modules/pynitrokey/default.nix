{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, certifi
, cffi
, click
, click-aliases
, cryptography
, ecdsa
, frozendict
, fido2
, intelhex
, nkdfu
, nrfutil
, python-dateutil
, pyusb
, requests
, semver
, spsdk
, tqdm
, urllib3
, tlv8
, typing-extensions
}:
buildPythonPackage rec {
  pname = "pynitrokey";
  version = "0.4.38";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8TMDbkRyTkzULrBeO0SL/WXB240LD/iZLigE/zPum2A=";
  };

  propagatedBuildInputs = [
    certifi
    cffi
    click
    click-aliases
    cryptography
    ecdsa
    frozendict
    fido2
    intelhex
    nkdfu
    nrfutil
    python-dateutil
    pyusb
    requests
    semver
    spsdk
    tqdm
    urllib3
    tlv8
    typing-extensions
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "cryptography"
    "protobuf"
    "python-dateutil"
    "spsdk"
    "typing_extensions"
  ];

  meta = with lib; {
    description = "Python Library for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/pynitrokey";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ mib ];
  };
}

