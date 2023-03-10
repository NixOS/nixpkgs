{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  pname = "asciitree";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "mbr";
    repo = pname;
    rev = version;
    sha256 = "071wlpyi8pa262sj9xdy0zbj163z84dasxad363z3sfndqxw78h1";
  };

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Draws ASCII trees";
    homepage = "https://github.com/mbr/asciitree";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
