{
  lib,
  buildPythonPackage,
  fetchurl,
  autoPatchelfHook,
  numpy,
  traits,
  pyside6,
  pythonOlder,
}:

buildPythonPackage {
  pname = "ovito";
  version = "3.14.1";
  format = "wheel";
  disabled = pythonOlder "3.13";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/76/6e/d9d636c5d6590f14cee5f9b4865f913a49f53bfc7f44104a33fc7233fa6f/ovito-3.14.1-cp313-cp313-manylinux_2_28_x86_64.whl";
    hash = "sha256-GF30rBzgm/ChOLuAmkhD81j532SgQay0+NKg2Mdwqbg=";
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
