{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  jinja2,
  mock,
  packaging,
  ply,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "stone";
  version = "3.3.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dropbox";
    repo = "stone";
    tag = "v${version}";
    hash = "sha256-3tUV2JrE3S2Tj/9aHvzfBTkIWUmWzkWNsVLr5yWRE/Q=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner == 5.3.2'," ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    jinja2
    ply
    six
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "stone" ];

  meta = with lib; {
    description = "Official API Spec Language for Dropbox API V2";
    homepage = "https://github.com/dropbox/stone";
    changelog = "https://github.com/dropbox/stone/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "stone";
  };
}
