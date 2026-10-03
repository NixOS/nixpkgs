{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  hypothesis,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pyroaring";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ezibenroc";
    repo = "PyRoaringBitMap";
    tag = version;
    hash = "sha256-7oHnYN44NVf2mjvHXaRgKtHFHMTQohpGEuQJjc9NGzw=";
  };

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "pyroaring" ];

  passthru.updateScript = nix-update-script { };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = {
    description = "Python library for handling efficiently sorted integer sets";
    homepage = "https://github.com/Ezibenroc/PyRoaringBitMap";
    changelog = "https://github.com/Ezibenroc/PyRoaringBitMap/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shymega ];
  };
}
