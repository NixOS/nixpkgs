{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "batinfo";
  version = "2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nicolargo";
    repo = "batinfo";
    tag = "v${version}";
    hash = "sha256-7oR8FRnl6reFHKPf49ZH3zQIjgOX1KTOxb3aCRNYOSg=";
  };

  postPatch = ''
    substituteInPlace test_batinfo.py \
      --replace-fail "self.assertEquals" "self.assertEqual"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "batinfo" ];

  disabledTests = [
    # Tests are a bit outdated
    "test_batinfo_capacity"
    "test_batinfo_charge_now"
    "test_batinfo_name_default"
  ];

  meta = {
    description = "Module to retrieve battery information";
    homepage = "https://github.com/nicolargo/batinfo";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ koral ];
    platforms = lib.platforms.linux;
  };
}
