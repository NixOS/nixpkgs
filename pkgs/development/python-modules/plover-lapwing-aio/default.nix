{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  plover-dict-commands,
  plover-last-translation,
  plover-modal-dictionary,
  plover-python-dictionary,
  plover-stitching,
}:

buildPythonPackage (finalAttrs: {
  pname = "plover-lapwing-aio";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aerickt";
    repo = "plover-lapwing-aio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+zXsbXwOtnj3feWdBujIYs7MdbB7VV3VWyio8CeJtB4=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "setuptools<77" "setuptools"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    plover-dict-commands
    plover-last-translation
    plover-modal-dictionary
    plover-python-dictionary
    plover-stitching
  ];

  pythonImportsCheck = [
    "plover_lapwing"
  ];

  meta = {
    description = "Plover plugin to automatically install Lapwing dictionaries, dependent plugins, extra dictionaries, and fix the number key behaviour";
    homepage = "https://github.com/aerickt/plover-lapwing-aio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pandapip1
      ShamrockLee
    ];
  };
})
