{ lib
, buildPythonPackage
, fetchFromGitHub
, chardet
, humanfriendly
, pytestCheckHook
, pythonOlder
, setuptools-scm
, smartmontools
}:

buildPythonPackage rec {
  pname = "pysmart";
  version = "1.2.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "truenas";
    repo = "py-SMART";
    rev = "v${version}";
    hash = "sha256-NqE7Twl1kxXrASyxw35xIOTB+LThU0a45NCxh8SUxfI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace pySMART/utils.py \
      --replace "which('smartctl')" '"${smartmontools}/bin/smartctl"'
  '';

  propagatedBuildInputs = [
    chardet
    humanfriendly
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pySMART"
  ];

  meta = with lib; {
    description = "Wrapper for smartctl (smartmontools)";
    homepage = "https://github.com/truenas/py-SMART";
    changelog = "https://github.com/truenas/py-SMART/blob/v${version}/CHANGELOG.md";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
