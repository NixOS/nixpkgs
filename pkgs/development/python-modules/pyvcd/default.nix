{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage rec {
  pname = "pyvcd";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-luPHuUCeY/WOtLXCKwF/nzQS3b38c0zsLh361cKag98=";
  };

  build-system = [ uv-build ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "vcd" ];

  meta = {
    description = "Python package for writing Value Change Dump (VCD) files";
    homepage = "https://github.com/SanDisk-Open-Source/pyvcd";
    changelog = "https://github.com/SanDisk-Open-Source/pyvcd/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sb0 ];
  };
}
