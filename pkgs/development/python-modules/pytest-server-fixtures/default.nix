{
  lib,
  buildPythonPackage,
  future,
  psutil,
  pytest,
  pytest-shutil,
  pytest-fixture-config,
  requests,
  retry,
  six,
  setuptools,
}:

buildPythonPackage {
  pname = "pytest-server-fixtures";
  inherit (pytest-fixture-config) version src patches;
  pyproject = true;

  postPatch = ''
    cd pytest-server-fixtures
  '';

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [
    future
    psutil
    pytest-shutil
    pytest-fixture-config
    requests
    retry
    six
  ];

  # Don't run integration tests
  doCheck = false;

  meta = with lib; {
    description = "Extensible server fixures for py.test";
    homepage = "https://github.com/manahl/pytest-plugins";
    license = licenses.mit;
    maintainers = [ ];
  };
}
