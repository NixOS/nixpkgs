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

buildPythonPackage (finalAttrs: {
  pname = "mammoth";
  version = "1.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "python-mammoth";
    tag = finalAttrs.version;
    hash = "sha256-F8lgtxlvM44qvHTv5wK6CKGepV6Jh+SWUoWEzdnLkEI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'read("README")' '""'
  '';

  build-system = [ setuptools ];

  dependencies = [ cobble ];

  nativeCheckInputs = [
    funk
    pytestCheckHook
    spur
    tempman
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "mammoth" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Convert Word documents (.docx files) to HTML";
    homepage = "https://github.com/mwilliamson/python-mammoth";
    changelog = "https://github.com/mwilliamson/python-mammoth/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
