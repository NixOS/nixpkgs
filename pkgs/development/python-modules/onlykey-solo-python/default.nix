{
  buildPythonPackage,
  click,
  ecdsa,
  fetchpatch,
  fetchPypi,
  fido2,
  intelhex,
  lib,
  pyserial,
  pyusb,
  requests,
}:

buildPythonPackage rec {
  pname = "onlykey-solo-python";
  version = "0.0.32";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-88DuhgX4FCwzIKzw4RqWgMtjRdf5huVlKEHAAEminuQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "fido2 == 0.9.3" "fido2"
  '';

  patches = [
    # https://github.com/trustcrypto/onlykey-solo-python/pull/3
    (fetchpatch {
      url = "https://github.com/trustcrypto/onlykey-solo-python/commit/dfebd6b36087f5f918da8c1af5a3236581cccf2d.patch";
      hash = "sha256-O0XQoWwhwvLc0CchUTXSuWgHMNG2ZPDy7FsU3RQrdp8=";
    })
  ];

  propagatedBuildInputs = [
    click
    ecdsa
    fido2
    intelhex
    pyserial
    pyusb
    requests
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "solo" ];

  meta = with lib; {
    homepage = "https://github.com/trustcrypto/onlykey-solo-python";
    description = "Python library for OnlyKey with Solo FIDO2";
    mainProgram = "solo";
    maintainers = with maintainers; [ kalbasit ];
    license = licenses.asl20;
  };
}
