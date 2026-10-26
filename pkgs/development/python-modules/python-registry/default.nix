{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  unicodecsv,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-registry";
  version = "1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "python-registry";
    tag = finalAttrs.version;
    hash = "sha256-OgRPcyx+NJnbtETMakUT0p8Pb0Qfzgj+qvWtmJksnT8=";
  };

  postPatch = ''
    substituteInPlace Registry/__init__.py \
      --replace-fail '1.3.1' '${finalAttrs.version}'
  '';

  pythonRemoveDeps = [ "enum-compat" ];

  build-system = [ setuptools ];

  dependencies = [ unicodecsv ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  disabledTestPaths = [ "samples" ];

  pythonImportsCheck = [ "Registry" ];

  meta = {
    description = "Module to parse the Windows Registry hives";
    homepage = "https://github.com/williballenthin/python-registry";
    changelog = "https://github.com/williballenthin/python-registry/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      debtquity
    ];
  };
})
