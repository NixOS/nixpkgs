{ fetchFromGitHub
, buildPythonPackage
, cargo
, rustPlatform
, rustc
, setuptools-rust
, numpy
, fixtures
, networkx
<<<<<<< HEAD
, testtools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libiconv
, stdenv
, lib
}:

buildPythonPackage rec {
  pname = "rustworkx";
<<<<<<< HEAD
  version = "0.13.1";
=======
  version = "0.12.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-WwQuvRMDGiY9VrWPfxL0OotPCUhCsvbXoVSCNhmIF/g=";
=======
    hash = "sha256-d/KCxhJdyzhTjwJZ+GsXJE4ww30iPaXcPngpCi4hBZw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
<<<<<<< HEAD
    hash = "sha256-QuzBJyM83VtB6CJ7i9/SFE8h6JbxkX/LQ9lOFSQIidU=";
=======
    hash = "sha256-imhiPj763iumRQb+oeBOpICD1nCvzZx+3yQWu1QRRQQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [ numpy ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

<<<<<<< HEAD
  checkInputs = [ fixtures networkx testtools ];
=======
  checkInputs = [ fixtures networkx ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [ "rustworkx" ];

  meta = with lib; {
<<<<<<< HEAD
    description = "A high performance Python graph library implemented in Rust";
=======
    description = "A high performance Python graph library implemented in Rust.";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/Qiskit/rustworkx";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
