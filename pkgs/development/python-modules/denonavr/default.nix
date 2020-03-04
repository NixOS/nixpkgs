{ lib, buildPythonPackage, fetchFromGitHub, isPy27, requests
, pytest, testtools, requests-mock }:

buildPythonPackage rec {
  pname = "denonavr";
  version = "0.7.10";

  src = fetchFromGitHub {
    owner = "scarface-4711";
    repo = "denonavr";
    rev = version;
    sha256 = "078nhr69f68nfazhmkf2sl7wiadqx96a5ry3ziggiy1xs04vflj7";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = !isPy27;
  checkInputs = [ pytest testtools requests-mock ];
  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = "https://github.com/scarface-4711/denonavr";
    description = "Automation Library for Denon AVR receivers.";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
