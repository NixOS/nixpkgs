{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-asyncio,
  nix-update-script,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "result";
  version = "0.17.0";
  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];

  src = fetchFromGitHub {
    owner = "rustedpy";
    repo = "result";
    rev = "v${version}";
    hash = "sha256-o+7qKxGQCeMUnsmEReggvf+XwQWFHRCYArYk3DxCa50=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"--flake8",' "" \
      --replace-fail '"--tb=short",' "" \
      --replace-fail '"--cov=result",' "" \
      --replace-fail '"--cov=tests",' "" \
      --replace-fail '"--cov-report=term",' "" \
      --replace-fail '"--cov-report=xml",' ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  passthru.updateScript = nix-update-script { };
  pythonImportsCheck = [ "result" ];

  meta = with lib; {
    description = "A simple Result type for Python 3 inspired by Rust, fully type annotated";
    homepage = "https://github.com/rustedpy/result";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ emattiza ];
  };
}
