{ lib, buildPythonPackage, fetchFromGitHub, isPy27, requests
, pytest, testtools, requests-mock }:

buildPythonPackage rec {
  pname = "denonavr";
  version = "0.7.12";

  src = fetchFromGitHub {
    owner = "scarface-4711";
    repo = "denonavr";
    rev = version;
    sha256 = "1i7r0f8ldxpy9vkwjla6rfkaq37071d36zfhb1dwm9jgp6ggi34m";
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
