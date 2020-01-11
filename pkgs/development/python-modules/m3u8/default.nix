{ lib, buildPythonPackage, python, fetchFromGitHub, requests, iso8601, bottle, pytest, pytestcov }:

buildPythonPackage rec {
  pname = "m3u8";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "globocom";
    repo = pname;
    rev = version;
    sha256 = "0p6wmwv1nfa5pyakq5d55w9v142z5ja3db3s3qr44kx895d9lhng";
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

