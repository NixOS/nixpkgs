{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "mss";
  version = "7.0.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8UzuUokDw7AdO48SCc1JhCL3Hj0NLZLFuTPt07l3ICI=";
  };

  # By default it attempts to build Windows-only functionality
  prePatch = ''
    rm mss/windows.py
  '';

  # Skipping tests due to most relying on DISPLAY being set
  pythonImportsCheck = [ "mss" ];

  meta = with lib; {
    description = "Cross-platform multiple screenshots module in pure Python";
    homepage = "https://github.com/BoboTiG/python-mss";
    license = licenses.mit;
    maintainers = with maintainers; [ austinbutler ];
  };
}
