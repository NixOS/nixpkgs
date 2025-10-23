{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ppx_js_style,
  ppx_yojson_conv_lib,
  ppxlib,
  version ? if lib.versionAtLeast ppxlib.version "0.36.0" then "0.17.1" else "0.15.1",
}:
buildDunePackage {
  pname = "ppx_yojson_conv";
  inherit version;

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "ppx_yojson_conv";
    tag = "v${version}";
    hash =
      {
        "0.15.1" = "sha256-lSOUSMVgsRiArEhFTKpAj2yFBPbtaIc/SxdPA+24xXs=";
        "0.17.1" = "sha256-QI2uN1/KeyDxdk6oxPt48lDir55Kkgx2BX6wKCY59LI=";
      }
      ."${version}";
  };

  propagatedBuildInputs = [
    ppx_js_style
    ppx_yojson_conv_lib
    ppxlib
  ];

  meta = with lib; {
    description = "PPX syntax extension that generates code for converting OCaml types to and from Yojson";
    homepage = "https://github.com/janestreet/ppx_yojson_conv";
    maintainers = with maintainers; [ djacu ];
    license = with licenses; [ mit ];
  };
}
