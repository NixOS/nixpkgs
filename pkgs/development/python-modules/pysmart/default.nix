{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  chardet,
  humanfriendly,
  pytestCheckHook,
  setuptools-scm,
  smartmontools,
}:

buildPythonPackage rec {
  pname = "pysmart";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "truenas";
    repo = "py-SMART";
    tag = "v${version}";
    hash = "sha256-A3SqSo7dUiHB3twlVxNb+7CWki1AZdxlYMQWDwCb9QQ=";
  };

  postPatch = ''
    substituteInPlace pySMART/utils.py \
      --replace "which('smartctl')" '"${smartmontools}/bin/smartctl"'
  '';

  propagatedBuildInputs = [
    chardet
    humanfriendly
  ];

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pySMART" ];

  meta = {
    description = "Wrapper for smartctl (smartmontools)";
    homepage = "https://github.com/truenas/py-SMART";
    changelog = "https://github.com/truenas/py-SMART/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
}
