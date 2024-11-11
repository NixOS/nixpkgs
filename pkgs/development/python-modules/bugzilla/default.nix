{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  responses,
  pytestCheckHook,
  glibcLocalesUtf8,
}:

buildPythonPackage rec {
  pname = "bugzilla";
  version = "3.3.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "python_${pname}";
    inherit version;
    sha256 = "sha256-4YIgFx4DPrO6YAxNE5NZ0BqhrOwdrrxDCJEORQdj3kc=";
  };

  propagatedBuildInputs = [ requests ];

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
