{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pkginfo,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "colorzero";
  version = "2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "waveform80";
    repo = "colorzero";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-0NoQsy86OHQNLZsTEuF5s2MlRUoacF28jNeHgFKAH14=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkginfo ];

  pythonImportsCheck = [ "colorzero" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Yet another Python color library";
    homepage = "https://github.com/waveform80/colorzero";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
