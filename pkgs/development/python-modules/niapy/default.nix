{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  openpyxl,
  pandas,
  uv-build,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage (finalAttrs: {
  pname = "niapy";
  version = "2.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NiaOrg";
    repo = "NiaPy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+5pixT0oWdRlpsi4t3/7iPThfmEcBkUN2FO8dAawtd4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.17,<0.10.0" "uv_build"
  '';

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
