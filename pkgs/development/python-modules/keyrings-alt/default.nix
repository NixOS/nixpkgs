{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy27, six
, pytest, backports_unittest-mock, keyring, setuptools-scm, toml
}:

buildPythonPackage rec {
  pname = "keyrings.alt";
  version = "4.0.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc475635099d6edd7e475c5a479e5b4da5e811a3af04495a1e9ada488d16fe25";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--flake8" ""
  '';

  nativeBuildInputs = [ setuptools-scm toml ];
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
