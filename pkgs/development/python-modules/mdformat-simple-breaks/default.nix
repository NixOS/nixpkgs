{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mdformat,
}:

buildPythonPackage rec {
  pname = "mdformat-simple-breaks";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "csala";
    repo = "mdformat-simple-breaks";
    tag = "v${version}";
    hash = "sha256-w0qPxIlCFMvs7p2Lya/ATkQN9wVt8ipsePZgonN/qpc=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ mdformat ];

  pythonImportsCheck = [ "mdformat_simple_breaks" ];

  meta = {
    description = "Mdformat plugin to render thematic breaks using three dashes";
    homepage = "https://github.com/csala/mdformat-simple-breaks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
}
