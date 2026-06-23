{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  plover,
}:

buildPythonPackage (finalAttrs: {
  pname = "plover-last-translation";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nsmarkop";
    repo = "plover_last_translation";
    tag = finalAttrs.version;
    hash = "sha256-G6IvJ/xkayqFR4D3LTPJae2qxRnDpUI0yKTEbtRUxUg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    plover
  ];

  pythonImportsCheck = [
    "plover_last_translation"
  ];

  meta = {
    description = "Plugins for Plover to repeat output";
    homepage = "https://github.com/nsmarkop/plover_last_translation";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      pandapip1
      ShamrockLee
    ];
  };
})
