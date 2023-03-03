{ lib, buildPythonPackage, fetchPypi, six, mock }:
buildPythonPackage rec {
  pname = "hiro";
  version = "1.1.1";
  src = fetchPypi {
    inherit pname version;

    hash = "sha256-2jM5rx3JpZTMqdycccclJysuMGYE5F0OBXXNE8X5XWg=";
  };

  propagatedBuildInputs = [ six mock ];

  meta = with lib; {
    description = "Time manipulation utilities for Python";
    homepage = "https://hiro.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ nyarly ];
  };
}
