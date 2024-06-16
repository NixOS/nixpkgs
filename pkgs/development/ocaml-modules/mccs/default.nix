{ lib, fetchFromGitHub, buildDunePackage, cudf }:

buildDunePackage rec {
  pname = "mccs";
  version = "1.1+13";

  src = fetchFromGitHub {
    owner = "AltGr";
    repo = "ocaml-mccs";
    rev = version;
    sha256 = "sha256-K249E9qkWNK4BC+ynaR3bVEyu9Tk8iCE7GptKk/aVJc=";
  };

  useDune2 = true;

  propagatedBuildInputs = [
    cudf
  ];

  doCheck = true;

  meta = with lib; {
    description = "A library providing a multi criteria CUDF solver, part of MANCOOSI project";
    downloadPage = "https://github.com/AltGr/ocaml-mccs";
    homepage = "https://www.i3s.unice.fr/~cpjm/misc/";
    license = with licenses; [ lgpl21 gpl3 ];
    maintainers = with maintainers; [ ];
  };
}
