{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

# This package provides a binary "apython" which sometimes invokes
# [sys.executable, '-m', 'aioconsole'] as a subprocess. If apython is
# run directly out of this derivation, it won't work, because
# sys.executable will point to a Python binary that is not wrapped to
# be able to find aioconsole.
# However, apython will work fine when using python##.withPackages,
# because with python##.withPackages the sys.executable is already
# wrapped to be able to find aioconsole and any other packages.
buildPythonPackage rec {
  pname = "aioconsole";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vxgmichel";
    repo = "aioconsole";
    rev = "refs/tags/v${version}";
    hash = "sha256-c8zeKebS04bZS9pMIKAauaLPvRrWaGoDKbnF906tFzQ=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov aioconsole --count 2" ""
  '';

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    "test_interact_syntax_error"
    # Output and the sandbox don't work well together
    "test_interact_multiple_indented_lines"
  ];

  pythonImportsCheck = [ "aioconsole" ];

  meta = with lib; {
    changelog = "https://github.com/vxgmichel/aioconsole/releases/tag/v${version}";
    description = "Asynchronous console and interfaces for asyncio";
    mainProgram = "apython";
    homepage = "https://github.com/vxgmichel/aioconsole";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ catern ];
  };
}
