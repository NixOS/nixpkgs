{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "routes";
  version = "1.0.0";

  useDune2 = true;
  minimalOCamlVersion = "4.05";

  src = fetchurl {
    url = "https://github.com/anuragsoni/routes/releases/download/${version}/routes-${version}.tbz";
    sha256 = "sha256-WSlASDTA1UX+NhW38/XuLkOkdwjIxz0OUkX6Nd2iROg=";
  };

  meta = with lib; {
    description = "Typed routing for OCaml applications";
    license = licenses.bsd3;
    homepage = "https://anuragsoni.github.io/routes";
    maintainers = with maintainers; [ ulrikstrid anmonteiro ];
  };
}
