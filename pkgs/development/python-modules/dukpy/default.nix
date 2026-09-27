{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mock,
  pytestCheckHook,
  setuptools,
  webassets,
}:

buildPythonPackage (finalAttrs: {
  pname = "dukpy";
  version = "0.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "amol-";
    repo = "dukpy";
    tag = finalAttrs.version;
    hash = "sha256-BSgKu5sjWMGJt2zH2vHnWXGTRLxlX/+Dz2/lBTDJuWM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    webassets
  ];

  preCheck = ''
    rm -r dukpy
  '';

  pythonImportsCheck = [ "dukpy" ];

  meta = {
    description = "Simple JavaScript interpreter for Python";
    homepage = "https://github.com/amol-/dukpy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ attila ];
    mainProgram = "dukpy";
  };
})
