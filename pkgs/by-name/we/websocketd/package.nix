{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "websocketd";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "joewalnes";
    repo = "websocketd";
    rev = "v${version}";
    sha256 = "sha256-cp4iBSQ6Cd0+NPZ2i79Mulg1z17u//OCm3yoArbZEHs=";
  };

  vendorHash = "sha256-i5IPJ3srUXL7WWjBW9w803VSoyjwA5JgPWKsAckPYxY=";

  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Turn any program that uses STDIN/STDOUT into a WebSocket server";
    homepage = "http://websocketd.com/";
    maintainers = [ lib.maintainers.bjornfor ];
    license = lib.licenses.bsd2;
=======
  meta = with lib; {
    description = "Turn any program that uses STDIN/STDOUT into a WebSocket server";
    homepage = "http://websocketd.com/";
    maintainers = [ maintainers.bjornfor ];
    license = licenses.bsd2;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "websocketd";
  };
}
