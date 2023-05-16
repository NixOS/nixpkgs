<<<<<<< HEAD
{ lib, stdenv, buildNimPackage, fetchFromGitea, nim-unwrapped, npeg }:

buildNimPackage (final: prev: {
  pname = "preserves";
  version = "20230801";
  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "ehmry";
    repo = "preserves-nim";
    rev = final.version;
    hash = "sha256-60QsbXMYYfEWvXQAXu7XSpvg2J9YaGKDkDrfclcK6pc=";
  };
  propagatedBuildInputs = [ npeg ];
  nimFlags = [ "--mm:refc" "--path:${nim-unwrapped}/nim" "--threads:off" ];
  doCheck = !stdenv.isDarwin;
  meta = final.src.meta // {
=======
{ lib, stdenv, buildNimPackage, fetchFromGitea, npeg }:

buildNimPackage rec {
  pname = "preserves";
  version = "20221102";
  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "ehmry";
    repo = "${pname}-nim";
    rev = version;
    hash = "sha256-oRsq1ugtrOvTn23596BXRy71TQZ4h/Vv6JGqBTZdoKY=";
  };
  propagatedBuildInputs = [ npeg ];
  doCheck = !stdenv.isDarwin;
  meta = src.meta // {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Nim implementation of the Preserves data language";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ehmry ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
