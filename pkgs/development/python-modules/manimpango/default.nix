{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  setuptools,
  pango,
  cython,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "manimpango";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ManimCommunity";
    repo = "manimpango";
    tag = "v${version}";
    hash = "sha256-8eQmhVsW440/zxOwjngnPTGT7iFbdSvBV7tnI332piE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython>=3.0.2,<3.1" Cython
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ pango ];

  build-system = [
    setuptools
    cython
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  preCheck = ''
    rm -r manimpango
  '';

  pythonImportsCheck = [ "manimpango" ];

  meta = {
    description = "Binding for Pango";
    homepage = "https://github.com/ManimCommunity/ManimPango";
    changelog = "https://github.com/ManimCommunity/ManimPango/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilytrau ];
  };
}
