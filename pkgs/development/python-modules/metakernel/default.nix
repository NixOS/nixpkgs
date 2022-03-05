{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
}:

buildPythonPackage rec {
  pname = "metakernel";
  version = "0.28.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8811a4497444495639ef000902f4c6e8a7e2c57da1d47a8a24bcc9083548b389";
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
