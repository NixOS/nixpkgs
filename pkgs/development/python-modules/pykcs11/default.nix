{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  setuptools,
  swig,
}:

buildPythonPackage rec {
  pname = "pykcs11";
  version = "1.5.21";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WBpS7dKdMzpCC1tCLdoLiKFMXsf6iYtY62lpRFo+RVQ=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ swig ];

  pypaBuildFlags = [ "--skip-dependency-check" ];

  outputs = [
    "out"
    "testout"
  ];

  postInstall = ''
    mkdir $testout
    cp -R test $testout/test
  '';

  pythonImportsCheck = [ "PyKCS11" ];

  doCheck = false;

  # tests complain about circular import, do testing with passthru.tests instead
  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    description = "PKCS#11 wrapper for Python";
    homepage = "https://github.com/LudovicRousseau/PyKCS11";
    changelog = "https://github.com/LudovicRousseau/PyKCS11/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hulr ];
  };
}
