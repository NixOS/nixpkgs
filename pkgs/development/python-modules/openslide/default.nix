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
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "openslide";
    repo = "openslide-python";
    tag = "v${version}";
    hash = "sha256-iI92lsW+hshMxl2rtc3/iq0LmQBuvpwqpqJXMXcCiLc=";
  };

  postPatch = ''
    substituteInPlace openslide/lowlevel.py \
      --replace-fail "return cdll.LoadLibrary(names[0])" "return cdll.LoadLibrary(f'${lib.getLib openslide}/lib/{names[0]}')"
  '';

  build-system = [ setuptools ];

  dependencies = [ pillow ];

  pythonImportsCheck = [ "openslide" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''rm -rf openslide/'';

  meta = {
    description = "Python bindings to the OpenSlide library for reading whole-slide microscopy images";
    homepage = "https://github.com/openslide/openslide-python";
    changelog = "https://github.com/openslide/openslide-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
