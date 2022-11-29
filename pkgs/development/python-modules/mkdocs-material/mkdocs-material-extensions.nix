{ lib
, fetchFromGitHub
, buildPythonPackage
, hatchling
}:

let
  pname = "mkdocs-material-extensions";
  version = "1.1.1";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = pname;
    rev = version;
    sha256 = "sha256-FHI6WEQRd/Ff6pmU13f8f0zPSeFhhbmDdk4/0rdIl4I=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  pythonImportsCheck = [ "materialx" ];

  meta = with lib; {
    description = "Markdown extension resources for MkDocs Material";
    homepage = "https://github.com/facelessuser/mkdocs-material-extensions";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
