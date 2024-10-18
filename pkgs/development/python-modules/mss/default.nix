{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mss";
  version = "9.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yWpOxzIk2n2yK8B+88+qGPi4aQDRhy4pETu87wCToh4=";
  };

  prePatch = ''
    # By default it attempts to build Windows-only functionality
    rm src/mss/windows.py
  '';

  # Skipping tests due to most relying on DISPLAY being set
  doCheck = false;

  pythonImportsCheck = [ "mss" ];

  meta = with lib; {
    description = "Cross-platform multiple screenshots module";
    mainProgram = "mss";
    homepage = "https://github.com/BoboTiG/python-mss";
    changelog = "https://github.com/BoboTiG/python-mss/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ austinbutler ];
  };
}
