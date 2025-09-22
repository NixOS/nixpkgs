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
    sha256 = "0nhvi48nc0bmad5ncyn6c9yc338krs3xf10bvv55xgz25c5gdgwy";
    fetchSubmodules = true; # Fetching by tag does not work otherwise
  };

  propagatedBuildInputs = [ six ];

  meta = {
    homepage = "https://github.com/ilya-kolpakov/jsondate";
    description = "JSON with datetime handling";
    license = lib.licenses.mit;
  };
}
