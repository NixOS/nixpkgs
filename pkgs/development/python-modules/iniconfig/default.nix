{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "iniconfig";
  version = "1.1.1";

  src = fetchFromGitHub {
     owner = "RonnyPfannschmidt";
     repo = "iniconfig";
     rev = "v1.1.1";
     sha256 = "0ysy6945513cbfnhzmvlk78qar1zk4pilmw50zsvpy3xd7nc14mz";
  };

  doCheck = false; # avoid circular import with pytest
  pythonImportsCheck = [ "iniconfig" ];

  meta = with lib; {
    description = "brain-dead simple parsing of ini files";
    homepage = "https://github.com/RonnyPfannschmidt/iniconfig";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
