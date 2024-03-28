{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, mkdocs
, wcmatch
}:

buildPythonPackage rec {
  pname = "mkdocs-include-markdown-plugin";
  version = "6.0.4";

  src = fetchFromGitHub {
    owner = "mondeja";
    repo = "mkdocs-include-markdown-plugin";
    rev = "v${version}";
    hash = "sha256-wHaDvF+QsEa3G5+q1ZUQQpVmwy+oRsSEq2qeJIJjFeY=";
  };

  pyproject = true;
  nativeBuildInputs = [ hatchling mkdocs ];
  propagatedBuildInputs = [ wcmatch ];

  meta = with lib; {
    description = "Mkdocs Markdown includer plugin";
    homepage = "https://github.com/mondeja/mkdocs-include-markdown-plugin";
    license = licenses.asl20;
    maintainers = with maintainers; [ caarlos0 ];
    changelog = "https://github.com/mondeja/mkdocs-include-markdown-plugin/releases/tag/${src.rev}";
  };
}
