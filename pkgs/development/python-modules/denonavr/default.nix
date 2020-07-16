{ lib, buildPythonPackage, fetchFromGitHub, isPy27, requests, netifaces
, pytest, testtools, requests-mock }:

buildPythonPackage rec {
  pname = "denonavr";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "scarface-4711";
    repo = "denonavr";
    rev = version;
    sha256 = "0s8v918n6xn44r2mrq5hqbf0znpz64clq7a1jakkgz9py8bi6vnn";
  };

  propagatedBuildInputs = [ requests netifaces ];

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
