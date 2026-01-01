{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "traitor";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "traitor";
    rev = "v${version}";
    sha256 = "sha256-LQfKdjZaTm5z8DUt6He/RJHbOUCUwP3CV3Fyt5rJIfU=";
  };

  vendorHash = null;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Automatic Linux privilege escalation";
    longDescription = ''
      Automatically exploit low-hanging fruit to pop a root shell. Traitor packages
      up a bunch of methods to exploit local misconfigurations and vulnerabilities
      (including most of GTFOBins) in order to pop a root shell.
    '';
    homepage = "https://github.com/liamg/traitor";
<<<<<<< HEAD
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
    platforms = platforms.linux;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
