{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "mss";
  version = "6.1.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "aebd069f3e05667fe9c7b9fa4b1771fe42a4710ce1058ce0236936ce06fa5394";
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
