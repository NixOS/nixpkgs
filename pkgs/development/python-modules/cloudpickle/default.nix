{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # tests
  psutil,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cloudpickle";
  version = "3.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloudpipe";
    repo = "cloudpickle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3GEmsJ/tFaVCcXsldYrItZJ2gE7Z2tPYrzdk+zVzlnU=";
  };

  build-system = [ flit-core ];

  # Needed to avoid "ModuleNotFoundError: No module named 'psutil'" in tests
  # not using only pythonpath but appending it env["PYTHONPATH"]
  postPatch = ''
    substituteInPlace tests/testutils.py \
      --replace-fail 'env["PYTHONPATH"] = pythonpath' 'env["PYTHONPATH"] = ":".join(filter(None, [pythonpath, env.get("PYTHONPATH")]))'
  '';

  nativeCheckInputs = [
    psutil
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cloudpickle" ];

  meta = {
    changelog = "https://github.com/cloudpipe/cloudpickle/blob/v${finalAttrs.version}/CHANGES.md";
    description = "Extended pickling support for Python objects";
    homepage = "https://github.com/cloudpipe/cloudpickle";
    license = lib.licenses.bsd3;
    maintainers = [
      lib.maintainers.Filippo-Galli
    ];
  };
})
