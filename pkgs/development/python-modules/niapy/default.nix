{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  openpyxl,
  pandas,
  pytest-xdist,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "niapy";
  version = "2.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NiaOrg";
    repo = "NiaPy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g3B/jknzMIYP8VJayPktnYwq2WVA2KaCRS/ZzVwc88Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.17,<0.10.0" "uv_build"
  '';

  pythonRelaxDeps = [ "numpy" ];

  build-system = [ uv-build ];

  dependencies = [
    matplotlib
    numpy
    openpyxl
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [ "niapy" ];

  meta = {
    description = "Micro framework for building nature-inspired algorithms";
    homepage = "https://niapy.org/";
    changelog = "https://github.com/NiaOrg/NiaPy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
