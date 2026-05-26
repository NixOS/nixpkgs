{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build inputs
  typing-extensions,
  uri-template,
}:

buildPythonPackage rec {
  pname = "json-home-client";
  version = "1.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "plinss";
    repo = "json_home_client";
    rev = "v${version}";
    hash = "sha256-DhnvvY1nMe1sdRE+OgjBt4TsLmiqnD8If4rl700zW9E=";
  };

  postPatch = ''
    sed -i -e 's/0.0.0/${version}/' setup.py
  '';

  propagatedBuildInputs = [
    typing-extensions
    uri-template
  ];

  pythonImportsCheck = [ "json_home_client" ];

  meta = {
    description = "Client class for calling http+json APIs in Python";
    homepage = "https://github.com/plinss/json_home_client";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
