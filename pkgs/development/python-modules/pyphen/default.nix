{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyphen";
  version = "0.16.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LABrPd8HLJVxq5dgbZqzwmqS6s7UwNWf0dJpiPMI9BM=";
  };

  nativeBuildInputs = [ flit ];

  preCheck = ''
    sed -i '/addopts/d' pyproject.toml
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyphen" ];

  meta = with lib; {
    description = "Module to hyphenate text";
    homepage = "https://github.com/Kozea/Pyphen";
    changelog = "https://github.com/Kozea/Pyphen/releases/tag/${version}";
    license = with licenses; [
      gpl2
      lgpl21
      mpl20
    ];
  };
}
