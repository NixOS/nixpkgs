{ lib
, buildPythonPackage
, fetchPypi
, hidapi
, pyscard
, ecdsa
 }:

buildPythonPackage rec {
  pname = "btchip-python";
  version = "0.1.32";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NPXgwWHAj2XcDQcLov9MMV7SHEt+D6oypGhi0Nwbj1U=";
  };

  postPatch = ''
    # fix extra_requires validation
    substituteInPlace setup.py \
      --replace "python-pyscard>=1.6.12-4build1" "python-pyscard>=1.6.12"
  '';

  propagatedBuildInputs = [
    hidapi
    ecdsa
  ];

  passthru.optional-dependencies.smartcard = [
    pyscard
  ];

  # tests requires hardware
  doCheck = false;

  pythonImportsCheck = [
    "btchip.btchip"
  ];

  meta = with lib; {
    description = "Python communication library for Ledger Hardware Wallet products";
    homepage = "https://github.com/LedgerHQ/btchip-python";
    license = licenses.asl20;
  };
}
