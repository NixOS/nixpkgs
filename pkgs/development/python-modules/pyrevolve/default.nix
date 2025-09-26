{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  contexttimer,
  setuptools,
  versioneer,
  cython_0,
  numpy,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyrevolve";
  version = "2.2.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devitocodes";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-jjiFOlxXjaa4L4IEtojeeS0jx4GsftAeIGBpJLhUcY4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace ', "flake8"' ""
  '';

  nativeBuildInputs = [
    cython_0
    setuptools
    versioneer
  ];

  propagatedBuildInputs = [
    contexttimer
    numpy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -rf pyrevolve
  '';

  pythonImportsCheck = [ "pyrevolve" ];

  meta = with lib; {
    homepage = "https://github.com/devitocodes/pyrevolve";
    changelog = "https://github.com/devitocodes/pyrevolve/releases/tag/${src.tag}";
    description = "Python library to manage checkpointing for adjoints";
    license = licenses.epl10;
    maintainers = with maintainers; [ atila ];
  };
}
