{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, isPy27
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "metakernel";
  version = "0.27.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aqq9zil6h7kxsg3v2008nr6lv47qvcsash8qzmi1xh6r4x606zy";
  };

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
