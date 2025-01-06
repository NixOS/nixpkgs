{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "prefixed";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FkQD+p68gygLvEcF9LJDoog34WQxC05lw4zKseuv7rM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "prefixed" ];

  meta = with lib; {
    description = "Prefixed alternative numeric library";
    homepage = "https://github.com/Rockhopper-Technologies/prefixed";
    changelog = "https://github.com/Rockhopper-Technologies/prefixed/releases/tag/${version}";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
