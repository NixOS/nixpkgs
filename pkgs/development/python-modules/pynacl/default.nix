{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, libsodium
, cffi
, six
, hypothesis
}:

buildPythonPackage rec {
  pname = "pynacl";
  version = "1.3.0";

  src = fetchPypi {
    inherit version;
    pname = "PyNaCl";
    sha256 = "0c6100edd16fefd1557da078c7a31e7b7d7a52ce39fdca2bec29d4f7b6e7600c";
  };

  checkInputs = [ pytest hypothesis ];
  buildInputs = [ libsodium ];
  propagatedBuildInputs = [ cffi six ];

  SODIUM_INSTALL = "system";

  # fixed in next release 1.3.0+
  # https://github.com/pyca/pynacl/pull/480
  postPatch = ''
    substituteInPlace tests/test_bindings.py \
      --replace "average_size=128," ""
  '';

  checkPhase = ''
    py.test
  '';

  # https://github.com/pyca/pynacl/issues/550
  PYTEST_ADDOPTS = "-k 'not test_wrong_types'";

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ va1entin ];
    description = "Python binding to the Networking and Cryptography (NaCl) library";
    homepage = https://github.com/pyca/pynacl/;
    license = licenses.asl20;
  };
}
