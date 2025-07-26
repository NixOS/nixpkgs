{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  hatchling,
  hatch-vcs,

  matplotlib,
}:

buildPythonPackage rec {
  pname = "matplotlib-scalebar";
  version = "0.9.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ppinard";
    repo = pname;
    tag = version;
    hash = "sha256-qVm3nfLzlrWnrKUP2fHCsUNkNDKABFDXwL5xcQ/FBDo=";
  };

  disabled = pythonOlder "3.9";

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    matplotlib
  ];

  pythonImportsCheck = [ "matplotlib_scalebar" ];

  meta = with lib; {
    description = "Provides a new artist for matplotlib to display a scale bar, aka micron bar";
    homepage = "https://github.com/ppinard/matplotlib-scalebar";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
