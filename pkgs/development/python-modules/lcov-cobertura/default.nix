{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  setuptools-scm,
  distutils,
}:

buildPythonPackage rec {
  pname = "lcov-cobertura";
  version = "2.1.1";
  pyproject = true;
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "lcov_cobertura";
    inherit version;
    hash = "sha256-76jiZPK93rt/UCTkrOErYz2dWQSLxkdCfR4blojItY8=";
  };

  # https://github.com/eriwen/lcov-to-cobertura-xml/issues/63
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail 'License :: OSI Approved :: Apache Software License' ""
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];
  dependencies = [ distutils ];

  pythonImportsCheck = [ "lcov_cobertura" ];

  meta = {
    description = "Converts code coverage from lcov format to Cobertura's XML format";
    mainProgram = "lcov_cobertura";
    homepage = "https://eriwen.github.io/lcov-to-cobertura-xml/";
    license = lib.licenses.asl20;
  };
}
