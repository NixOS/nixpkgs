{ lib
, fetchFromGitHub
, python3
}:

let
  pname = "chromaprint";
  version = "0.5";
in
python3.pkgs.buildPythonPackage rec {
  inherit pname;
  inherit version;

  src = python3.pkgs.fetchPypi {
    inherit pname;
    inherit version;
    hash = "sha256-d4M+ieNQpIXcnEH1WyIWnTYZe3P+Y58W0uz1uYPwLQE=";
  };

  propagatedBuildInputs = with python3.pkgs; [ m2r ];

  meta = with lib; {
    description = "Facilitate effortless color terminal output";
    homepage = "https://pypi.org/project/${pname}/";
    license = licenses.mit;
    maintainers = with maintainers; [ dschrempf ];
  };
}
