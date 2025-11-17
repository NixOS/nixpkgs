{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  stdcompat,
  ppxlib,
}:

buildDunePackage rec {
  pname = "ppx_show";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "thierry-martinez";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YwWAdOtb0zg2hqNkGRiigz/Pci8Jy/QD+WyUEohEsns=";
  };

  buildInputs = [
    stdcompat
    ppxlib
  ];

  meta = with lib; {
    homepage = "https://github.com/thierry-martinez/${pname}";
    description = "OCaml PPX deriver for deriving show based on ppxlib";
    license = licenses.bsd2;
    maintainers = with maintainers; [ niols ];
  };
}
