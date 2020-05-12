{ lib, buildPythonPackage, fetchFromGitHub, isPy27, requests
, pytest, testtools, requests-mock }:

buildPythonPackage rec {
  pname = "denonavr";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "scarface-4711";
    repo = "denonavr";
    rev = version;
    sha256 = "12g9w5674fmyf3f4plbhvpxpyhzw32pzwl0hvwswzrc2823xl6vx";
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
