{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "playsound";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "TaylorSMarks";
    repo = "playsound";
    rev = "v${version}";
    hash = "sha256-zXPTvbm5159/85sThn5+uGX0lP8iG+8IvgqsSgMxeEk=";
  };

  doCheck = false;

  pythonImportsCheck = [ "playsound" ];

  meta = {
    homepage = "https://github.com/TaylorSMarks/playsound";
    description = "Pure Python, cross platform, single function module with no dependencies for playing sounds";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
