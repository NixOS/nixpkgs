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
  version = "1.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "truenas";
    repo = "py-SMART";
    tag = "v${version}";
    hash = "sha256-eVrJ83MTIlu7sDrOoaXwiWqxYmDJFU8tf+pb3ui9N5w=";
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
