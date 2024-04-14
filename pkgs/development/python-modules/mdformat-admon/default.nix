{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, mdformat
, mdit-py-plugins
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdformat-admon";
  version = "2.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-admon";
    rev = "refs/tags/v${version}";
    hash = "sha256-TybbkF6+dIfG+1fGYp+bTEdw2GXINZJfOX0QiAaqiWY=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    mdformat
    mdit-py-plugins
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Mdformat plugin for admonitions";
    homepage = "https://github.com/KyleKing/mdformat-admon";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
