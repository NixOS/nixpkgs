{ lib
, fetchPypi
, buildPythonPackage
, flit-core
, matplotlib
, pytestCheckHook
, imageio
, scipy
, pypng
, meshzoo
, networkx
, scikit-fem
}:

buildPythonPackage rec {
  pname = "matplotx";
  version = "0.3.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oAP5ouRjcgztgGL6xUPQCHxsK+7cdQcmeYQcaL2EcaY=";
  };

  propagatedBuildInputs = [
    flit-core
    matplotlib
    networkx
    pypng
    scipy
  ];

  checkInputs = [
    imageio
    meshzoo
    pytestCheckHook
    scikit-fem
  ];

  pythonImportsCheck = [ "matplotx" ];

  meta = with lib; {
    description = "Useful styles and extensions for Matplotlib";
    homepage = "https://github.com/nschloe/matplotx";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
