{
  lib,
  buildPythonPackage,
  fetchPypi,
  cryptography,
  python-axolotl-curve25519,
  protobuf,
}:

buildPythonPackage rec {
  pname = "python-axolotl";
  version = "0.2.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/g6BR0I/jcTsEHfqGMpaVAkTZtIvqpA6dy7m6oi4ja8=";
  };

  propagatedBuildInputs = [
    cryptography
    python-axolotl-curve25519
    protobuf
  ];

  meta = with lib; {
    homepage = "https://github.com/tgalal/python-axolotl";
    description = "Python port of libaxolotl-android";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl3;
  };
}
