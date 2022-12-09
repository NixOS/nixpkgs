{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, ipykernel
}:

buildPythonPackage rec {
  pname = "metakernel";
  version = "0.29.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-A++uLR4hhOQYmA6o9wBTejFju3CpbK0hwIs7XFscddQ=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [ ipykernel ];

  # Tests hang, so disable
  doCheck = false;

  meta = with lib; {
    description = "Jupyter/IPython Kernel Tools";
    homepage = "https://github.com/Calysto/metakernel";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thomasjm ];
  };
}
