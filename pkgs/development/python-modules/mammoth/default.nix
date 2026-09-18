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
  version = "1.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "python-mammoth";
    tag = version;
    hash = "sha256-0I03noHNSa02yg3biVdgs9kBS/DdeOTPC5UzKV0S7m0=";
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

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Convert Word documents (.docx files) to HTML";
    homepage = "https://github.com/mwilliamson/python-mammoth";
    changelog = "https://github.com/mwilliamson/python-mammoth/blob/${src.tag}/NEWS";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
