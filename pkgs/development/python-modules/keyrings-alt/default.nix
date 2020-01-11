{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, isPy27, six
, pytest, backports_unittest-mock, keyring, setuptools_scm
}:

buildPythonPackage rec {
  pname = "keyrings.alt";
  version = "3.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "91328ac4229e70b1d0061d21bf61d36b031a6b4828f2682e38c741812f6eb23d";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--flake8" ""
  '';

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest keyring ] ++ stdenv.lib.optional (pythonOlder "3.3") backports_unittest-mock;

  # heavily relies on importing tests from keyring package
  doCheck = false;
  checkPhase = ''
    py.test
  '';

  pythonImportsCheck = [
    "keyrings.alt"
  ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    description = "Alternate keyring implementations";
    homepage = https://github.com/jaraco/keyrings.alt;
    maintainers = with maintainers; [ nyarly ];
  };
}
