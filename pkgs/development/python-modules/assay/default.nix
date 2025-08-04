{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
}:

buildPythonPackage {
  pname = "assay";
  version = "0-unstable-2024-05-09";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "brandon-rhodes";
    repo = "assay";
    rev = "74617d70e77afa09f58b3169cf496679ac5d5621";
    hash = "sha256-zYpLtcXZ16EJWKSCqxFkSz/G9PwIZEQGBrYiJKuqnc4=";
  };

  pythonImportsCheck = [ "assay" ];

  meta = {
    homepage = "https://github.com/brandon-rhodes/assay";
    description = "Attempt to write a Python testing framework I can actually stand";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zane ];
  };
}
