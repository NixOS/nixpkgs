{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "purl";
  version = "1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "codeinthehole";
    repo = "purl";
    rev = version;
    hash = "sha256-Jb3JRW/PtQ7NlO4eQ9DmTPu/sjvFTg2mztphoIF79gc=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "purl" ];

  meta = with lib; {
    description = "Immutable URL class for easy URL-building and manipulation";
    homepage = "https://github.com/codeinthehole/purl";
    license = licenses.mit;
    maintainers = [ ];
  };
}
