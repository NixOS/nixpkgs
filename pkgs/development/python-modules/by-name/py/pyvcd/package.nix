{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "0.4.1";
  format = "setuptools";
  pname = "pyvcd";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3GJ16Vp5SbgjYIarLm0Dr+3nNEEkPsUQnJ6okHfz1pY=";
  };

  buildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python package for writing Value Change Dump (VCD) files";
    homepage = "https://github.com/SanDisk-Open-Source/pyvcd";
    changelog = "https://github.com/SanDisk-Open-Source/pyvcd/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sb0
    ];
  };
}
