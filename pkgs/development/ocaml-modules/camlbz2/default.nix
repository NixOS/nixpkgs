{ lib, stdenv, fetchFromGitLab, ocaml, findlib, bzip2, autoconf, automake }:

stdenv.mkDerivation rec {
  pname = "camlbz2";
  version = "0.7.0";

  src = fetchFromGitLab {
    owner = "irill";
    repo = "camlbz2";
    rev = version;
    sha256 = "sha256-jBFEkLN2fbC3LxTu7C0iuhvNg64duuckBHWZoBxrV/U=";
  };

  preConfigure = ''
    aclocal -I .
    autoconf
  '';

  nativeBuildInputs = [
    autoconf
    automake
  ];

  buildInputs = [
    ocaml
    findlib
    bzip2
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    make install DESTDIR=$out
    runHook postInstall
  '';

  # passthru.tests = { inherit dose3; }; # To-Do: To be enabled when Dose3 PR is accepted.

  meta = with lib; {
    description = "CamlBZ2, OCaml bindings for the libbz2 (AKA, bzip2) (de)compression library.";
    downloadPage = "https://gitlab.com/irill/camlbz2";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ superherointj ];
  };
}
