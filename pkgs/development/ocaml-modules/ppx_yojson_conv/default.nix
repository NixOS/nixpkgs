{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppx_js_style,
  ppx_yojson_conv_lib,
  ppxlib,
}:

let params =
  if lib.versionAtLeast ppx_js_style.version "0.16" then {
    version = "0.16.0";
    hash = "sha256-8KpAwG0DCw9v4RtDcb3Y/BYX+ggqsRlSWAQ0NIFaIhk=";
    minimalOCamlVersion = "4.14";
  } else {
    version = "0.15.1";
    hash = "sha256-lSOUSMVgsRiArEhFTKpAj2yFBPbtaIc/SxdPA+24xXs=";
    minimalOCamlVersion = "4.08";
  };

in

buildDunePackage rec {
  pname = "ppx_yojson_conv";
  inherit (params) version minimalOCamlVersion;
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    inherit (params) hash;
  };

  propagatedBuildInputs = [
    ppx_js_style
    ppx_yojson_conv_lib
    ppxlib
  ];

  meta = with lib; {
    description = "A PPX syntax extension that generates code for converting OCaml types to and from Yojson";
    homepage = "https://github.com/janestreet/ppx_yojson_conv";
    maintainers = with maintainers; [djacu];
    license = with licenses; [mit];
  };
}
