{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  plover,
}:

buildPythonPackage (finalAttrs: {
  pname = "plover-modal-dictionary";
  # See https://pypi.org/project/plover-modal-dictionary/#history
  # and https://github.com/Kaoffie/plover_modal_dictionary/issues/3
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kaoffie";
    repo = "plover_modal_dictionary";
    rev = "086f9784377454ace45c333d21ea8ca2666b0a06";
    hash = "sha256-d5BYkjeGXfoYQibjr5wQFUmXU69dNrewkJ/Gi4c9eEI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    plover
  ];

  pythonImportsCheck = [
    "plover_modal_dictionary"
  ];

  meta = {
    description = "Modal Dictionaries for Plover";
    homepage = "https://github.com/Kaoffie/plover_modal_dictionary";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pandapip1
      ShamrockLee
    ];
  };
})
