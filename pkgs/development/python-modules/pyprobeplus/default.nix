{
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyprobeplus";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pantherale0";
    repo = "pyprobeplus";
    tag = finalAttrs.version;
    hash = "sha256-ezBf+ynSz/3r3UXgDOtFwLg6mT8wv+YQ6J55SSVyYUI=";
  };

  postPatch = ''
    substituteInPlace pyprobeplus/__init__.py \
      --replace-fail "1.0.1" "${finalAttrs.version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  pythonImportsCheck = [ "pyprobeplus" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/pantherale0/pyprobeplus/releases/tag/${finalAttrs.src.tag}";
    description = "Generic library to interact with a Probe Plus BLE device";
    homepage = "https://github.com/pantherale0/pyprobeplus";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
