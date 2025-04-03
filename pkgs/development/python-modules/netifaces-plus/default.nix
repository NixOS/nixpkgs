{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "netifaces-plus";
  version = "0.12.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tsukumijima";
    repo = "netifaces-plus";
    tag = "release_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-3CYAe0doWMagcUIN9+ikH9gEST9AqglSQDlZsKOMnC8=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "netifaces" ];

  meta = {
    description = "Portable network interface information";
    homepage = "https://github.com/tsukumijima/netifaces-plus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
