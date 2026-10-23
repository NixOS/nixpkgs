{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyirishrail";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ttroy50";
    repo = "pyirishrail";
    tag = version;
    hash = "sha256-NgARqhcXP0lgGpgBRiNtQaSn9JcRNtCcZPljcL7t3Xc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version='0.0.1'," "version='${version}',"
  '';

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyirishrail" ];

  meta = {
    description = "Python library to get the real-time transport information (RTPI) from Irish Rail";
    homepage = "https://github.com/ttroy50/pyirishrail";
    changelog = "https://github.com/ttroy50/pyirishrail/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
