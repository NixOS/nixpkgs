{ lib
, fetchFromGitHub
, buildPythonPackage
, hatchling
}:

buildPythonPackage rec {
  pname = "mkdocs-material-extensions";
  version = "1.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FHI6WEQRd/Ff6pmU13f8f0zPSeFhhbmDdk4/0rdIl4I=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  doCheck = false; # Circular dependency

  pythonImportsCheck = [ "materialx" ];

  meta = with lib; {
    description = "Markdown extension resources for MkDocs Material";
    homepage = "https://github.com/facelessuser/mkdocs-material-extensions";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
