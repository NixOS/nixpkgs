{
  lib,
  buildPythonPackage,
  fetchurl,
}:

buildPythonPackage rec {
  pname = "ovito";
  version = "3.14.0";
  format = "wheel";
  pyproject = true;

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/b0/73/87b8f942f02a72d5f39ce1eb842c4290a7ef3e841f48a835f29dbc48b670/ovito-3.14.0-cp312-cp312-manylinux_2_28_x86_64.whl";
    hash = "sha256-bEr5wAGCzGV7Ll3k71NSwlDvqk9rl3g2eM+qmYBMlwU=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  autoPatchelfIgnoreMissingDeps = [
    "libcuda.so.1"
    "libnvidia-ml.so.1"
  ];

  dependencies = [
    numpy
    traits
    pyside6
  ];

  meta = {
    description = "OVITO python module enabling OVITO's I/O, analysis and rendering capabilities in standalone python scripts.";
    homepage = "https://docs.ovito.org/python/index.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sh4k095 ];
  };
}
