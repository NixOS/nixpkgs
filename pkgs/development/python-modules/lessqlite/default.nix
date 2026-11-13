{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  click,
  coveralls,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "lessqlite";
  version = "0.1.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dvanderweele";
    repo = "lessqlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UtJkQaAwM1NkuKbd8oOx8iW5reuyd33Vdo1ZZYO0VB0=";
  };

  # Otherwise, fails with:
  # python3.14 -m wheel: error: unrecognized arguments: unpacked/lessqlite-0.1.1
  postUnpack = ''
    rm -r "$sourceRoot/dist"
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    click
    coveralls
  ];

  pythonRelaxDeps = [
    "coveralls"
  ];

  pythonImportsCheck = [
    "lessqlite"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A less-like command-line utility for easily paging through SQLite databases";
    homepage = "https://github.com/dvanderweele/lessqlite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ atemu ];
  };
})
