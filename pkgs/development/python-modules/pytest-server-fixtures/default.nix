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

buildPythonPackage rec {
  pname = "pytest-server-fixtures";
  inherit (pytest-fixture-config) version src;
  pyproject = true;

  sourceRoot = "${src.name}/pytest-server-fixtures";

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

  # Don't run intergration tests
  doCheck = false;

  meta = with lib; {
    description = "Extensible server fixures for py.test";
    homepage = "https://github.com/manahl/pytest-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
