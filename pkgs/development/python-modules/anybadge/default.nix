{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pytestCheckHook,
  pythonOlder,
  requests,
  sh,
}:

buildPythonPackage rec {
  pname = "anybadge";
  version = "1.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jongracecox";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-9qGmiIGzVdWHMyurMqTqEz+NKYlc/5zt6HPsssCH4Pk=";
  };

  # replace version info, also remove the need for git to check the tag for build
  postPatch = ''
    substituteInPlace ./setup.py \
      --replace 'version=get_version()' 'version="${version}"'

    substituteInPlace ./anybadge/__init__.py \
      --replace '"0.0.0"' '"${version}"'
  '';

  dependencies = [ packaging ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
    sh
  ];

  disabledTests = [
    # Comparison of CLI output fails
    "test_module_same_output_as_main_cli"
  ];

  disabledTestPaths = [
    # No anybadge-server
    "tests/test_server.py"
  ];

  pythonImportsCheck = [ "anybadge" ];

  meta = with lib; {
    description = "Python tool for generating badges for your projects";
    homepage = "https://github.com/jongracecox/anybadge";
    changelog = "https://github.com/jongracecox/anybadge/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fabiangd ];
  };
}
