{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppx_js_style,
  ppx_yojson_conv_lib,
  ppxlib,
}:
buildDunePackage rec {
  pname = "ppx_yojson_conv";
  version = "0.15.1";
  duneVersion = "3";
  minimalOCamlVersion = "4.08.0";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lSOUSMVgsRiArEhFTKpAj2yFBPbtaIc/SxdPA+24xXs=";
  };

  propagatedBuildInputs = [
    ppx_js_style
    ppx_yojson_conv_lib
    ppxlib
  ];

  meta = with lib; {
    description = "PPX syntax extension that generates code for converting OCaml types to and from Yojson";
    homepage = "https://github.com/janestreet/ppx_yojson_conv";
    maintainers = with maintainers; [djacu];
    license = with licenses; [mit];
  };
}
