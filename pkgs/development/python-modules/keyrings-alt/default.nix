{ lib, stdenv, buildPythonPackage, fetchPypi, pythonOlder, isPy27, six
, pytest, backports_unittest-mock, keyring, setuptools_scm, toml
}:

buildPythonPackage rec {
  pname = "keyrings.alt";
  version = "4.0.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd23d4c6930b5271134ac815d868164cb6d0d2252ee6dcb07fadfca26caaa230";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--flake8" ""
  '';

  nativeBuildInputs = [ setuptools_scm toml ];
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

  meta = with lib; {
    license = licenses.mit;
    description = "Alternate keyring implementations";
    homepage = "https://github.com/jaraco/keyrings.alt";
    maintainers = with maintainers; [ nyarly ];
  };
}
