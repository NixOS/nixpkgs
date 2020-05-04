{ lib
, buildPythonPackage
, fetchFromGitHub
, pam
}:

buildPythonPackage rec {
  pname = "python-pam";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "FirefighterBlu3";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gp7vzd332j7jwndcnz7kc9j283d6lyv32bndd1nqv9ghzv69sxp";
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
    maintainers = with maintainers; [ mkg20001 ];
  };
}
