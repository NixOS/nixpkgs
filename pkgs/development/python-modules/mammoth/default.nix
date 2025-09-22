{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cobble,
  funk,
  pytestCheckHook,
  spur,
  tempman,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "mammoth";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "python-mammoth";
    tag = version;
    hash = "sha256-I+PHag4e+RA6EppRTyBe/ywFsRhS+pZZHTh+g151l7Y=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'read("README")' '""'
  '';

  build-system = [ setuptools ];

  dependencies = [ cobble ];

  pythonImportsCheck = [ "mammoth" ];

  nativeCheckInputs = [
    funk
    pytestCheckHook
    spur
    tempman
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  passthru.updateScripts = gitUpdater { };

  meta = {
    description = "Convert Word documents (.docx files) to HTML";
    homepage = "https://github.com/mwilliamson/python-mammoth";
    changelog = "https://github.com/mwilliamson/python-mammoth/blob/${src.tag}/NEWS";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ];
  };
}
