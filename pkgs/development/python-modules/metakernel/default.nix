{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
}:

buildPythonPackage rec {
  pname = "metakernel";
  version = "0.28.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b57eb7b3b332614dcba1fa53c8cc1253dbccf962b111517ea16cbecce9a11d5";
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
