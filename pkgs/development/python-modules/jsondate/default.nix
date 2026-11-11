{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  six,
}:

buildPythonPackage rec {
  version = "0.1.3";
  format = "setuptools";
  pname = "jsondate";

  src = fetchFromGitHub {
    owner = "ilya-kolpakov";
    repo = "jsondate";
    tag = "v${version}";
    hash = "sha256-nr/2Civiv17K3gsE14fOE43BfGLGemZLU3UBZhGJG1o=";
    fetchSubmodules = true; # Fetching by tag does not work otherwise
  };

  propagatedBuildInputs = [ six ];

  meta = {
    homepage = "https://github.com/ilya-kolpakov/jsondate";
    description = "JSON with datetime handling";
    license = lib.licenses.mit;
  };
}
