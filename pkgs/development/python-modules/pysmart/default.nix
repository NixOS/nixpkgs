{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  chardet,
  humanfriendly,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  smartmontools,
}:

buildPythonPackage rec {
  pname = "pysmart";
  version = "1.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "truenas";
    repo = "py-SMART";
    tag = "v${version}";
    hash = "sha256-h9FBAoNYLs5XvLxSajyktCCcNgiT7mIp472C+fbqZFA=";
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

  meta = with lib; {
    description = "Wrapper for smartctl (smartmontools)";
    homepage = "https://github.com/truenas/py-SMART";
    changelog = "https://github.com/truenas/py-SMART/blob/${src.tag}/CHANGELOG.md";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
