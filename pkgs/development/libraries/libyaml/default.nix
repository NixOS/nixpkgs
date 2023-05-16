{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libyaml";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "yaml";
    repo = "libyaml";
    rev = version;
    sha256 = "18zsnsxc53pans4a01cs4401a2cjk3qi098hi440pj4zijifgcsb";
  };

<<<<<<< HEAD
  outputs = [ "out" "dev" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://pyyaml.org/";
    description = "A YAML 1.1 parser and emitter written in C";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
