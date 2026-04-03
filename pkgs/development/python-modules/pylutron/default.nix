{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  telnetlib3,
}:

buildPythonPackage rec {
  pname = "pylutron";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thecynic";
    repo = "pylutron";
    tag = version;
    hash = "sha256-y5RDwlIxmwzKihTDFZKoOJL+TPJbY05MKPUMs2hBWiw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail TEMPLATE_VERSION ${version}
  '';

  build-system = [ setuptools ];

  dependencies = [
    telnetlib3
  ];

  pythonImportsCheck = [ "pylutron" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests"
  ];

  meta = {
    description = "Python library for controlling a Lutron RadioRA 2 system";
    homepage = "https://github.com/thecynic/pylutron";
    changelog = "https://github.com/thecynic/pylutron/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
