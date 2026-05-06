{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  prompt-toolkit,
}:

buildPythonPackage rec {
  pname = "clintermission";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sebageek";
    repo = "clintermission";
    tag = "v${version}";
    hash = "sha256-e7C9IDr+mhVSfU8lMywjX1BYwFo/qegPNzabak7UPcY=";
  };

  propagatedBuildInputs = [ prompt-toolkit ];

  # repo contains no tests
  doCheck = false;

  pythonImportsCheck = [ "clintermission" ];

  meta = {
    description = "Non-fullscreen command-line selection menu";
    homepage = "https://github.com/sebageek/clintermission";
    changelog = "https://github.com/sebageek/clintermission/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
