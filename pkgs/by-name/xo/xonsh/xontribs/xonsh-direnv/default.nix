{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  direnv,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xonsh-direnv";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "74th";
    repo = pname;
    rev = version;
    hash = "sha256-bp1mK+YO9htEQcRSD5wJkAZtQKK2t3IOW7Kdc6b8Lb0=";
  };

  propagatedBuildInputs = [
    direnv
  ];

  nativeBuildInputs = [
    setuptools
  ];

  meta = with lib; {
    description = "Direnv support for Xonsh";
    homepage = "https://github.com/74th/xonsh-direnv/";
    license = licenses.mit;
    maintainers = with maintainers; [ greg ];
  };
}
