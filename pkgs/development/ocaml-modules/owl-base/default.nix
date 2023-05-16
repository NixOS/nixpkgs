{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "owl-base";
<<<<<<< HEAD
  version = "1.1";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/owlbarn/owl/releases/download/${version}/owl-${version}.tbz";
<<<<<<< HEAD
    hash = "sha256-mDYCZ2z33VTEvc6gV4JTecIXA/vHIWuU37BADGl/yog=";
=======
    hash = "sha256-ONIQzmwcLwljH9WZUUMOTzZLWuA2xx7RsyzlWbKikmM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  minimalOCamlVersion = "4.10";

  meta = with lib; {
    description = "Numerical computing library for Ocaml";
    homepage = "https://ocaml.xyz";
    changelog = "https://github.com/owlbarn/owl/releases";
    platforms = platforms.x86_64;
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
  };
}
