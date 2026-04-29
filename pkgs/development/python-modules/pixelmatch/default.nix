{
  lib,
  buildPythonPackage,
  fetchgit,
  pillow,
  poetry-core,
  pytestCheckHook,
  pytest-benchmark,
}:
buildPythonPackage rec {
  pname = "pixelmatch";
  version = "0.4.0";
  pyproject = true;

  src = fetchgit {
    url = "https://github.com/whtsky/pixelmatch-py.git";
    tag = "v${version}";
    hash = "sha256-tl1y8SASS8XR3ix4DLvwi5OoIs73oxYOF9Z90jPIU4o=";
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
