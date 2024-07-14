{
  lib,
  buildPythonPackage,
  fetchPypi,
  docutils,
}:

buildPythonPackage rec {
  pname = "rst2ansi";
  version = "0.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gxf7mmKNQPV5M60aOqlSNGREvgaUaVCOc+lQYNoz/m8=";
  };

  propagatedBuildInputs = [ docutils ];

  meta = with lib; {
    description = "Rst converter to ansi-decorated console output";
    mainProgram = "rst2ansi";
    homepage = "https://github.com/Snaipe/python-rst-to-ansi";
    license = licenses.mit;
    maintainers = with maintainers; [ vojta001 ];
  };
}
