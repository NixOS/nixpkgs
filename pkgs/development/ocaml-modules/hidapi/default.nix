{ pkgs, lib, fetchFromGitHub, buildDunePackage, pkg-config, dune-configurator
, bigstring,
}:

buildDunePackage rec {
  pname = "hidapi";
  version = "1.2.1";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "vbmithr";
    repo = "ocaml-hidapi";
    rev = version;
    hash = "sha256-upygm5G46C65lxaiI6kBOzLrWxzW9qWb6efN/t58SRg=";
  };

  minimalOCamlVersion = "4.03";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pkgs.hidapi dune-configurator ];
  propagatedBuildInputs = [ bigstring ];

  doCheck = true;

  meta = with lib; {
    description = "Bindings to Signal11's hidapi library";
    homepage = "https://github.com/vbmithr/ocaml-hidapi";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
    mainProgram = "ocaml-hid-enumerate";
  };
}
