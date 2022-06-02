{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
}:

buildPythonPackage rec {
  pname = "metakernel";
  version = "0.29.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+B8ywp7q42g8H+BPFK+D1VyLfyqgnrYIN3ai/mdcwcA=";
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
