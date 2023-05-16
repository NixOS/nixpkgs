{ lib, buildDunePackage, fetchFromGitHub, ocaml_pcre }:

buildDunePackage rec {
  pname = "duppy";
<<<<<<< HEAD
  version = "0.9.3";
=======
  version = "0.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-duppy";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-5U/CNQ88Wi/AgJEoFeS9O0zTPiD9ysJNQohRVJdyH9w=";
=======
    sha256 = "132dawca1p5s965m40ldmnihlpgfm47y62kfbzgim7sgsdwxxw5y";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ ocaml_pcre ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-duppy";
    description = "Library providing monadic threads";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
