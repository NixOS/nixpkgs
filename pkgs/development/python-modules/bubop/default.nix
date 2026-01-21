{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  loguru,
  python-dateutil,
  pyyaml,
  tqdm,
  click,
}:

buildPythonPackage rec {
  pname = "bubop";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "bubop";
    tag = "v${version}";
    hash = "sha256-NXA3UDOkCoj4dm3UO/X0w2Mpx4bw3yFO6oyOzsPgtrU=";
  };

  postPatch = ''
    # Those versions seems to work with `bubop`.
    substituteInPlace pyproject.toml \
    --replace-fail 'loguru = "^0.5.3"' 'loguru = "^0.7"' \
    --replace-fail 'PyYAML = "~5.3.1"' 'PyYAML = "^6.0"'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    loguru
    python-dateutil
    pyyaml
    tqdm
    click
  ];

  pythonImportsCheck = [ "bubop" ];

  meta = {
    description = "Bergercookie's Useful Bits Of Python; helper libraries for Bergercookie's programs";
    homepage = "https://github.com/bergercookie/bubop";
    changelog = "https://github.com/bergercookie/bubop/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raitobezarius ];
  };
}
