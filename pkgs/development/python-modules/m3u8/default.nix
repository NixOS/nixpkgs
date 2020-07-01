{ lib, buildPythonPackage, python, fetchFromGitHub, requests, iso8601, bottle, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "m3u8";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "globocom";
    repo = pname;
    rev = version;
    sha256 = "0cmg993icpsa1b19kljxvjwhs167bsqrs0ad4wnwsi8qq6na5d4p";
  };

  checkInputs = [ bottle pytest pytestcov ];

  checkPhase = ''
    pytest tests/test_{parser,model,variant_m3u8}.py
  '';

  propagatedBuildInputs = [ requests iso8601 ];

  meta = with lib; {
    homepage = "https://github.com/globocom/m3u8";
    description = "Python m3u8 parser";
    license = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}

