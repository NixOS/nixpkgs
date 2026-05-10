{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  markdown,
}:

buildPythonPackage (finalAttrs: {
  pname = "obsidian-media";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GooRoo";
    repo = "obsidian-media";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+JerHkpQExP2ytYFFxNbsvAJInUqVg/483KtywP38/g=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    markdown
  ];

  pythonImportsCheck = [
    "obsidian_media"
  ];

  # No tests are available
  doCheck = false;

  meta = {
    description = "";
    homepage = "https://github.com/GooRoo/obsidian-media";
    license = with lib.licenses; [
      bsd3
      cc0
    ];
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "obsidian-media";
  };
})
