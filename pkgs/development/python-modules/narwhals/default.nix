{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
}:
let
  pname = "narwhals";
  version = "1.9.3";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Wz9SwCqGcwphFJfm/7rMqj34b8JkcMI+P7QNwrx5Prs=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  pythonImportsCheck = [ "narwhals" ];

  meta = with lib; {
    description = "Lightweight and extensible compatibility layer between dataframe libraries";
    homepage = "https://narwhals-dev.github.io/narwhals";
    changelog = "https://github.com/narwhals-dev/narwhals/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      dmadisetti
    ];
  };
}
