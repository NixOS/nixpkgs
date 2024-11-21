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
  version = "0.12.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tsukumijima";
    repo = "netifaces-plus";
    rev = "refs/tags/release_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-0nOl8JDwttN8kI6qHxA5LbELXx1iyQEHqKXbhREBMeY=";
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
