{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-nodejs-version,
  hatchling,

  # dependencies
  pycrdt,
  pytestCheckHook,

  # tests
  websockets,
  ypy-websocket,
}:

buildPythonPackage rec {
  pname = "jupyter-ydoc";
<<<<<<< HEAD
  version = "3.3.3";
=======
  version = "3.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "jupyter_ydoc";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-crhJ1jEr5gyNMNPQgN41+cduO6WSii9OnWbKDcVNX3w=";
=======
    hash = "sha256-PGZu3CVF8X9LeFr8HRD7G6LcYoq/RPbqztopopFcAuA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatch-nodejs-version
    hatchling
  ];

  dependencies = [ pycrdt ];

  pythonImportsCheck = [ "jupyter_ydoc" ];

  nativeCheckInputs = [
    pytestCheckHook
    websockets
    ypy-websocket
  ];

  # requires a Node.js environment
  doCheck = false;

  meta = {
    changelog = "https://github.com/jupyter-server/jupyter_ydoc/blob/${src.tag}/CHANGELOG.md";
    description = "Document structures for collaborative editing using Ypy";
    homepage = "https://github.com/jupyter-server/jupyter_ydoc";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
}
