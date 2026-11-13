{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  objprint,
  pdm-backend,
  pygments,
  pytestCheckHook,
  python-slugify,
}:

buildPythonPackage (finalAttrs: {
  pname = "marko";
  version = "2.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frostming";
    repo = "marko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YFFv49JILk1VB8KhK3d0IK1A9fShFyy1Qvk7hGO45PM=";
  };

  build-system = [ pdm-backend ];

  optional-dependencies = {
    codehilite = [ pygments ];
    repr = [ objprint ];
    toc = [ python-slugify ];
  };

  pythonImportsCheck = [ "marko" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  meta = {
    description = "Markdown parser with high extensibility";
    homepage = "https://github.com/frostming/marko";
    changelog = "https://github.com/frostming/marko/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
