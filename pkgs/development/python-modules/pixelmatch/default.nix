{
  lib,
  buildPythonPackage,
  fetchgit,
  pillow,
  poetry-core,
  pytestCheckHook,
  pytest-benchmark,
  pythonOlder,
}:
let
  owner = "whtsky";
  repo = "pixelmatch-py";
in
buildPythonPackage rec {
  pname = "pixelmatch";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchgit {
    url = "https://github.com/whtsky/pixelmatch-py.git";
    tag = "v${version}";
    hash = "sha256-xq0LT7v83YRz0baw24iDXiuUxiNPMEsiZNIewsH3JPw=";
    fetchLFS = true;
  };

  build-system = [
    poetry-core
  ];

  nativeCheckInputs = [
    pillow
    pytest-benchmark
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pixelmatch" ];

  meta = {
    description = "A pixel-level image comparison library";
    homepage = "https://github.com/whtsky/pixelmatch-py";
    changelog = "https://github.com/whtsky/pixelmatch-py/tree/v${version}#changelog";
    license = with lib.licenses; [ isc ];
    teams = [ lib.teams.geospatial ];
  };
}
