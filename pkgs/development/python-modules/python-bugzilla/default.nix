{
  lib,
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
    glibcLocalesUtf8
    responses
  ];

  preCheck = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';

  meta = with lib; {
    homepage = "https://github.com/python-bugzilla/python-bugzilla";
    description = "Bugzilla XMLRPC access module";
    mainProgram = "bugzilla";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pierron ];
  };
}
