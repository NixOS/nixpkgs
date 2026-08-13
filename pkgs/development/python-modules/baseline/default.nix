{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  isPy3k,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "baseline";
  version = "1.2.1";
  pyproject = true;

  __structuredAttrs = true;

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "dmgass";
    repo = "baseline";
    rev = "95a0b71806ed16310eb0f27bc48aa5e21f731423";
    hash = "sha256-DQTd3OYo7gCaKAlnCKuwmHPq47kl44/lpk46f6MhT2I=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "baseline" ];

  meta = {
    description = "Easy String Baseline";
    mainProgram = "baseline";
    longDescription = ''
      This tool streamlines creation and maintenance of tests which compare
      string output against a baseline.
    '';
    homepage = "https://github.com/dmgass/baseline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dnr ];
  };
}
