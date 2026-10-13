{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  uv-build,
  click,
  quart,
  rtree,
}:

buildPythonPackage (finalAttrs: {
  pname = "gerbonara";
  version = "1.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "gerbonara";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XWxYgnzvebO+iTL6idWyX+j7bsyvNkWdKDEuqsU/p4w=";
  };

  build-system = [ uv-build ];

  dependencies = [
    click
    quart
    rtree
  ];

  pythonImportsCheck = [ "gerbonara" ];

  # Test environment is exceptionally tricky to get set up, so skip for now.
  doCheck = false;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Pythonic library for reading/modifying/writing Gerber/Excellon/IPC-356 files";
    homepage = "https://github.com/jaseg/gerbonara";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wulfsta ];
    mainProgram = "gerbonara";
  };
})
