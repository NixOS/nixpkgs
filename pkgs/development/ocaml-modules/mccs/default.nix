{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  cudf,
}:

buildDunePackage rec {
  pname = "mccs";
  version = "1.1+18";

  src = fetchFromGitHub {
    owner = "AltGr";
    repo = "ocaml-mccs";
    rev = version;
    hash = "sha256-Swfqq7O5KASf1nkK/lgIO9byWDUv1FiWh8cNULF7wfI=";
  };

  propagatedBuildInputs = [
    cudf
  ];

  doCheck = true;

  meta = with lib; {
    description = "Library providing a multi criteria CUDF solver, part of MANCOOSI project";
    downloadPage = "https://github.com/AltGr/ocaml-mccs";
    homepage = "https://www.i3s.unice.fr/~cpjm/misc/";
    license = with licenses; [
      lgpl21
      gpl3
    ];
    maintainers = [ ];
  };
}
