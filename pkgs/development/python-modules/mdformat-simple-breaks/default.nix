{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
}:

buildPythonPackage rec {
  pname = "mdformat-simple-breaks";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "csala";
    repo = "mdformat-simple-breaks";
    tag = "v${version}";
    hash = "sha256-4lJHB4r9lI2uGJ/BmFFc92sumTRKBBwiRmGBdQkzfd0=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ mdformat ];

  pythonImportsCheck = [ "mdformat_simple_breaks" ];

  meta = with lib; {
    description = "Mdformat plugin to render thematic breaks using three dashes";
    homepage = "https://github.com/csala/mdformat-simple-breaks";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
