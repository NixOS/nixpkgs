{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
  uv-build,
  wrapt,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-insta";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vberlier";
    repo = "pytest-insta";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zOhWDaCGkE/Ke2MLRyttDH85t+I9kfBZZwVDRN1sprs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.8,<0.10.0" "uv_build"
  '';

  pythonRelaxDeps = [ "wrapt" ];

  build-system = [ uv-build ];

  buildInputs = [ pytest ];

  dependencies = [ wrapt ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_insta" ];

  meta = {
    description = "Pytest plugin for snapshot testing";
    homepage = "https://github.com/vberlier/pytest-insta";
    changelog = "https://github.com/vberlier/pytest-insta/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
