{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
}:

buildPythonPackage rec {
  pname = "poetry-plugin-export";
  version = "1.0.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-wZbXIAGKTvbcYN1Sx9MCPVIiHxHzdpbLOVShHBEWUVU=";
  };

  postPatch = ''
    sed -i '/poetry =/d' pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  # infinite recursion with poetry
  doCheck = false;
  pythonImportsCheck = [];

  meta = with lib; {
    description = "Poetry plugin to export the dependencies to various formats";
    license = licenses.mit;
    homepage = "https://github.com/python-poetry/poetry-plugin-export";
    maintainers = with maintainers; [ hexa ];
  };
}
