{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-ipmi";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kontron";
    repo = "python-ipmi";
    tag = finalAttrs.version;
    hash = "sha256-yCMT0HRpRFoC8yv5f/VKtbRdf0JuwqJRbraLPaniTek=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=version," "version='${finalAttrs.version}',"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyipmi" ];

  meta = {
    description = "Python IPMI Library";
    homepage = "https://github.com/kontron/python-ipmi";
    changelog = "https://github.com/kontron/python-ipmi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ipmitool.py";
  };
})
