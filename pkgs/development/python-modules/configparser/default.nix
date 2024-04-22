{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "configparser";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "configparser";
    rev = "refs/tags/v${version}";
    hash = "sha256-r+poK+knBQi48Z1VrNFqUt9Qm9iGERAOTFa4bKfXi0g=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preConfigure = ''
    export LC_ALL=${if stdenv.isDarwin then "en_US" else "C"}.UTF-8
  '';

  meta = with lib; {
    description = "Updated configparser from Python 3.7 for Python 2.6+.";
    homepage = "https://github.com/jaraco/configparser";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
