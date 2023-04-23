{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mss";
  version = "7.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8UzuUokDw7AdO48SCc1JhCL3Hj0NLZLFuTPt07l3ICI=";
  };

  # By default it attempts to build Windows-only functionality
  prePatch = ''
    rm mss/windows.py
  '';

  # Skipping tests due to most relying on DISPLAY being set
  pythonImportsCheck = [
    "mss"
  ];

  meta = with lib; {
    description = "Cross-platform multiple screenshots module";
    homepage = "https://github.com/BoboTiG/python-mss";
    license = licenses.mit;
    maintainers = with maintainers; [ austinbutler ];
  };
}
