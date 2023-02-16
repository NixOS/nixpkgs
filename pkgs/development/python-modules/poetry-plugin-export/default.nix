{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
}:

buildPythonPackage rec {
  pname = "poetry-plugin-export";
  version = "1.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xrAGjHFYRT6n+r/16b0xyoI7+1Q1Hsw3lEK92UabIqo=";
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
    changelog = "https://github.com/python-poetry/poetry-plugin-export/blob/${src.rev}/CHANGELOG.md";
    description = "Poetry plugin to export the dependencies to various formats";
    license = licenses.mit;
    homepage = "https://github.com/python-poetry/poetry-plugin-export";
    maintainers = with maintainers; [ hexa ];
  };
}
