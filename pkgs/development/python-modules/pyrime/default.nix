{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  librime,
  autopxd2,
  meson-python,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyrime";
  version = "0.2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "rimeinn";
    repo = "pyrime";
    tag = version;
    hash = "sha256-M5BEMvaWmTCh+DE2LrW5WqiOCXqMy2MlvAdCmK+GJ+w=";
  };

  nativeBuildInputs = [ cython autopxd2 meson-python ];

  buildInputs = [
    librime
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyrime" ];

  meta = {
    description = "rime for python";
    homepage = "https://pyrime.readthedocs.io/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ Freed-Wu ];
  };
}
