{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, isPy27, six
, pytest, backports_unittest-mock, keyring, setuptools_scm
}:

buildPythonPackage rec {
  pname = "keyrings.alt";
  version = "3.5.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "252eb8955b7060c1f64c9a78320cebb4c63266cad415000e760731e0730fc551";
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
    homepage = "https://github.com/jaraco/keyrings.alt";
    maintainers = with maintainers; [ nyarly ];
  };
}
