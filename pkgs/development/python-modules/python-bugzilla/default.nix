{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  responses,
  pytestCheckHook,
  glibcLocalesUtf8,
}:

buildPythonPackage rec {
  pname = "python-bugzilla";
  version = "3.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_bugzilla";
    inherit version;
    hash = "sha256-4YIgFx4DPrO6YAxNE5NZ0BqhrOwdrrxDCJEORQdj3kc=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.buildPlatform glibcLocalesUtf8) [
    glibcLocalesUtf8
  ];

  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';

  meta = {
    homepage = "https://github.com/python-bugzilla/python-bugzilla";
    description = "Bugzilla XMLRPC access module";
    mainProgram = "bugzilla";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pierron ];
  };
}
