{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "n2g";
  version = "0.3.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dmulyalin";
    repo = "N2G";
    rev = version;
    sha256 = "sha256-Ur/P8hG0bvZx2AqWEvf1PwWLZRxJ8GduUjuFPIWS4NM=";
  };

  propagatedBuildInputs = [ poetry ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "n2g" ];

  meta = with lib; {
    description = "Library to generate diagrams in yWorks graphml or drawio formats or JSON data compatible with 3d-force-graph JSON input";
    homepage = "https://github.com/dmulyalin/N2G";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
