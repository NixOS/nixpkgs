{ lib
, buildPythonPackage
, fetchFromGitHub
, pam
}:

buildPythonPackage rec {
  pname = "python-pam";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "FirefighterBlu3";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-MR9LYXtkbltAmn7yoyyKZn4yMHyh3rj/i/pA8nJy2xU=";
  };

  buildInputs = [
    pam
  ];

  postPatch = ''
    sed "s|find_library(\"pam\")|\"${pam}/lib/libpam.so\"|g" -i pam.py
  '';

  meta = with lib; {
    description = "Python pam module supporting py3 (and py2)";
    homepage = "https://github.com/FirefighterBlu3/python-pam";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar mkg20001 ];
  };
}
