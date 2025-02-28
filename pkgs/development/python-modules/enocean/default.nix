{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  setuptools,

  # dependencies
  beautifulsoup4,
  pyserial,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "enocean";
  version = "0.60.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kipe";
    repo = "enocean";
    tag = version;
    hash = "sha256-S62YvRP1bvEzzzMd/jMjIdHAZsUImF9EQhsrPPzebDE=";
  };

  patches = [
    (fetchpatch2 {
      name = "replace-nose-with-pytest.patch";
      url = "https://github.com/kipe/enocean/commit/e5ca3b70f0920f129219c980ad549d7f3a4576de.patch";
      hash = "sha256-cDBvI0I4W5YkGTpg+rKy08TUAmKlhKa/5+Muou9iArs=";
    })
  ];

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "enum-compat" ];

  dependencies = [
    beautifulsoup4
    pyserial
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "enocean.communicators"
    "enocean.protocol.packet"
    "enocean.utils"
  ];

  meta = with lib; {
    changelog = "https://github.com/kipe/enocean/releases/tag/${version}";
    description = "EnOcean serial protocol implementation";
    mainProgram = "enocean_example.py";
    homepage = "https://github.com/kipe/enocean";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
