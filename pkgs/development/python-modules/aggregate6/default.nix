{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  py-radix-sr,
  versionCheckHook,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aggregate6";
  version = "1.0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "job";
    repo = "aggregate6";
    rev = version;
    hash = "sha256-sF5F4AIIQuMTuWE3zoBE1akJX9QSmAaRp1qgoHzSJMo=";
  };

  # py-radix-sr is a fork, with fixes
  # NOTE: it should be worth switching to py-radix again in the future as there
  #       is still development sadly currently without a new release.
  postPatch = ''
    substituteInPlace setup.py --replace-fail 'py-radix==0.10.0' 'py-radix-sr'
  '';

  build-system = [ setuptools ];

  dependencies = [ py-radix-sr ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "aggregate6" ];
  versionCheckProgramArg = "-V";

  meta = {
    description = "IPv4 and IPv6 prefix aggregation tool";
    mainProgram = "aggregate6";
    homepage = "https://github.com/job/aggregate6";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ marcel ];
    teams = [ lib.teams.wdz ];
  };
}
