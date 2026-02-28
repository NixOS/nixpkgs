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

buildPythonPackage rec {
  pname = "gerbonara";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "gerbonara";
    tag = "v${version}";
    hash = "sha256-kzEjfM9QrT+izwyCnNdN6Bv6lk1rzqs7tfDvERzJzzI=";
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
    mainProgram = "gerbonara";
    homepage = "https://github.com/jaseg/gerbonara";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ wulfsta ];
  };
}
