{ lib, buildPythonPackage, fetchPypi, setuptools, python, which }:

buildPythonPackage rec {
  pname = "nodeenv";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4Of337hfxTlMb+Ho+pgTGiRz4EMRpFr7ZQj3zxg2+is=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  # Tests not included in PyPI tarball
  doCheck = false;

  preFixup = ''
    substituteInPlace $out/${python.sitePackages}/nodeenv.py \
      --replace '["which", candidate]' '["${lib.getBin which}/bin/which", candidate]'
  '';

  pythonImportsCheck = [ "nodeenv" ];

  meta = with lib; {
    description = "Node.js virtual environment builder";
    homepage = "https://github.com/ekalinin/nodeenv";
    license = licenses.bsd3;
  };
}
