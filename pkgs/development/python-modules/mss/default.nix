{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "mss";
  version = "6.0.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dicp55adbqxb7hqlck95hngb1klv5s26lszw3xim30k18bwqaxl";
  };

  propagatedBuildInputs = [ ];

  # By default it attempts to build Windows-only functionality
  prePatch = ''
    rm mss/windows.py
  '';

  # Skipping tests due to most relying on DISPLAY being set
  pythonImportsCheck = [ "mss" ];

  meta = with lib; {
    description = "Cross-platform multiple screenshots module in pure Python";
    homepage = "https://github.com/BoboTiG/mss/";
    license = licenses.mit;
    maintainers = with maintainers; [ austinbutler ];
  };
}
