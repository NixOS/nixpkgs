{ alcotest
, buildDunePackage
, dune-configurator
, fetchFromGitHub
, lib
, ocaml
, openssl
, pkg-config
}:

buildDunePackage rec {
  pname = "ssl";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.5.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ssl";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-gi80iwlKaI4TdAVnCyPG03qRWFa19DHdTrA0KMFBAc4=";
=======
    rev = version;
    sha256 = "sha256-Ws7QZOvZVy0QixMiBFJZEOnYzYlCWrZ1d95gOp/a5a0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ openssl ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ alcotest ];
  preCheck = ''
    mkdir -p _build/default/tests/
    cp tests/digicert_certificate.pem _build/default/tests/
  '';

  meta = {
    homepage = "http://savonet.rastageeks.org/";
    description = "OCaml bindings for libssl ";
    license = "LGPL+link exception";
    maintainers = with lib.maintainers; [ anmonteiro dandellion maggesi ];
  };
}
