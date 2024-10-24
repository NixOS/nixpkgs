{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
}:
buildPythonPackage rec {
  pname = "files-to-prompt";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "files-to-prompt";
    rev = "refs/tags/${version}";
    hash = "sha256:gl3j0ok/hlFfIF3HhhzYrUZuNlAtU7y+Ej29sQv9tP4=";
  };

  build-system = [ setuptools ];

  dependencies = [ click ];

  pythonImportsCheck = [ "files_to_prompt" ];

  meta = with lib; {
    description = "Concatenate a directory full of files into a single prompt for use with LLMs";
    homepage = "https://github.com/simonw/files-to-prompt";
    changelog = "https://github.com/simonw/files-to-prompt/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ janschill ];
  };
}
