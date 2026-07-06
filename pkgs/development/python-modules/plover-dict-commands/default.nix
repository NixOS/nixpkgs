{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  plover,
}:

buildPythonPackage (finalAttrs: {
  pname = "plover-dict-commands";
  # See https://pypi.org/project/plover-dict-commands/
  # and https://github.com/KoiOates/plover_dict_commands/issues/4
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KoiOates";
    repo = "plover_dict_commands";
    rev = "5dceddc0830fb5a72679d62995f27b2e49850998";
    hash = "sha256-PXsYMqJz8sxgloEtiwxxt6Eo0hyFp5oW0homIAYPz6A=";
  };

  postPatch = ''
    # See https://github.com/KoiOates/plover_dict_commands/issues/4
    substituteInPlace setup.cfg \
      --replace-fail "version = 0.2.4" "version = 0.2.5"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    plover
  ];

  pythonImportsCheck = [
    "plover_dict_commands"
  ];

  meta = {
    description = "Plover plugin for enabling, disabling, and changing the priority of dictionaries";
    homepage = "https://github.com/KoiOates/plover_dict_commands";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      pandapip1
      ShamrockLee
    ];
  };
})
