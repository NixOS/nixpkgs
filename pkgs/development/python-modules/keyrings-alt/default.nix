{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy27, six
, pytest, backports_unittest-mock, keyring, setuptools-scm
}:

buildPythonPackage rec {
  pname = "keyrings.alt";
  version = "4.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "52ccb61d6f16c10f32f30d38cceef7811ed48e086d73e3bae86f0854352c4ab2";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--flake8" ""
  '';

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest keyring ] ++ lib.optional (pythonOlder "3.3") backports_unittest-mock;

  # heavily relies on importing tests from keyring package
  doCheck = false;
  checkPhase = ''
    py.test
  '';

  pythonImportsCheck = [
    "keyrings.alt"
  ];

  meta = with lib; {
    license = licenses.mit;
    description = "Alternate keyring implementations";
    homepage = "https://github.com/jaraco/keyrings.alt";
    maintainers = with maintainers; [ nyarly ];
  };
}
