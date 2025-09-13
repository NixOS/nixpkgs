{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pillow,
  poetry-core,
  pytest-benchmark,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pixelmatch";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "whtsky";
    repo = "pixelmatch-py";
    tag = "v${version}";
    hash = "sha256-aggZKq+364Nj34oD9GNgyHREiKNJFixbgo3nAmE6hTQ=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pillow
    pytest-benchmark
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pixelmatch" ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  # Issue with loading the fixtures
  doCheck = false;

  meta = {
    description = "Pixel-level image comparison library";
    homepage = "https://github.com/whtsky/pixelmatch-py";
    changelog = "https://github.com/whtsky/pixelmatch-py/releases/tag/${src.tag}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fab ];
  };
}
