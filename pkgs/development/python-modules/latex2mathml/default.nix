{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  pytestCheckHook,
  pytest-cov-stub,
  multidict,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "latex2mathml";
  version = "3.81.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = "latex2mathml";
    tag = finalAttrs.version;
    hash = "sha256-NY8SVEN9i8OcT8YS8887/TgLuIYAsS26me2BqGW0ubs=";
  };

  build-system = [ uv-build ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    multidict
    syrupy
  ];

  # nixpkgs is only at uv_build 0.10.0
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.10.11,<0.11.0' 'uv_build'
  '';

  pythonImportsCheck = [ "latex2mathml" ];

  meta = {
    description = "Pure Python library for LaTeX to MathML conversion";
    homepage = "https://github.com/roniemartinez/latex2mathml";
    changelog = "https://github.com/roniemartinez/latex2mathml/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "latex2mathml";
    maintainers = with lib.maintainers; [ sfrijters ];
  };
})
