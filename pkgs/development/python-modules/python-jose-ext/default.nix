{ lib, fetchPypi, buildPythonPackage, six, future, pycryptodomex, ecdsa }:

buildPythonPackage rec {
  pname = "python-jose-ext";
  version = "1.3.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "135b62sv00qj3fjgs5ji4r5pl1frrza8bls2q4gkz0bxsrgkigda";
  };

  patchPhase = ''
    substituteInPlace setup.py --replace "pycryptodomex ==3.4.9" "pycryptodomex >=3.4.9"
  '';

  buildInputs = [ six future pycryptodomex ecdsa ];

  doCheck = false;

  meta = {
    homepage = https://github.com/mpdavis/python-jose;
    description = "extensions for jose";
    maintainers = with lib.maintainers; [ mog ];
    license = lib.licenses.mit;
  };
}
