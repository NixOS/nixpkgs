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
  version = "1.5.16";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q9dGsGd/Q8xjS598Tastm6axqDuTHiWYJHBi+P9kHgc=";
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

  meta = with lib; {
    description = "PKCS#11 wrapper for Python";
    homepage = "https://github.com/LudovicRousseau/PyKCS11";
    changelog = "https://github.com/LudovicRousseau/PyKCS11/releases/tag/${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hulr ];
  };
}
