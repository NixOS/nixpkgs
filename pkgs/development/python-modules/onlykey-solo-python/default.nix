{ buildPythonPackage
, click
, ecdsa
, fetchpatch
, fetchPypi
, fido2
, intelhex
, lib
, pyserial
, pyusb
, requests
}:

buildPythonPackage rec {
  pname = "onlykey-solo-python";
  version = "0.0.32";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-88DuhgX4FCwzIKzw4RqWgMtjRdf5huVlKEHAAEminuQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "fido2 == 0.9.3" "fido2"
  '';

  patches = [
    # https://github.com/trustcrypto/onlykey-solo-python/pull/2
    (fetchpatch {
      url = "https://github.com/trustcrypto/onlykey-solo-python/commit/c5a86506f940d4e8fbb670ed665ddca48779cbe9.patch";
      hash = "sha256-LhCUR5QH9Je/Nr185HgQxfkCtat8W2Huv62zr5Mlrn4=";
    })
  ];

  propagatedBuildInputs = [ click ecdsa fido2 intelhex pyserial pyusb requests ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "solo" ];

  meta = with lib; {
    homepage = "https://github.com/trustcrypto/onlykey-solo-python";
    description = "Python library for OnlyKey with Solo FIDO2";
    maintainers = with maintainers; [ kalbasit ];
    license = licenses.asl20;
  };
}

