{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  openslide,
  pillow,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "openslide";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "openslide";
    repo = "openslide-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-GokWpRuon8lnxNzxsYGYrQBQDhGPxl8HDaO7fR+2Ldo=";
  };

  postPatch = ''
    substituteInPlace openslide/lowlevel.py \
      --replace-fail "return cdll.LoadLibrary(name)" "return cdll.LoadLibrary(f'${lib.getLib openslide}/lib/{name}')"
  '';

  build-system = [ setuptools ];

  dependencies = [ pillow ];

  pythonImportsCheck = [ "openslide" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''rm -rf openslide/'';

  meta = {
    description = "Python bindings to the OpenSlide library for reading whole-slide microscopy images";
    homepage = "https://github.com/openslide/openslide-python";
    changelog = "https://github.com/openslide/openslide-python/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
