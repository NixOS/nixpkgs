{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  setuptools,
  setuptools-scm,
  hypothesis,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "multivolumefile";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "multivolume";
    tag = "v${version}";
    hash = "sha256-7gjfF7biQZOcph2dfwi2ouDn/uIYik/KBQ0k6u5Ne+Q=";
  };

  postPatch =
    # Fix typo: `tools` -> `tool`
    # upstream PR: https://codeberg.org/miurahr/multivolume/pulls/9
    ''
      substituteInPlace pyproject.toml \
        --replace-fail 'tools.setuptools_scm' 'tool.setuptools_scm'
    '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "multivolumefile"
  ];

  meta = {
    description = "Library to provide a file-object wrapping multiple files as virtually like as a single file";
    homepage = "https://codeberg.org/miurahr/multivolume";
    changelog = "https://codeberg.org/miurahr/multivolume/src/tag/v${version}/Changelog.rst#v${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      pitkling
      PopeRigby
    ];
  };
}
