{
  lib,
  fetchurl,
  fetchpatch,
  applyPatches,
  buildDunePackage,
  cppo,
  gettext,
  fileutils,
  ounit2,
}:

buildDunePackage rec {
  pname = "gettext";
  version = "0.5.0";

  src = applyPatches {
    src = fetchurl {
      url = "https://github.com/gildor478/ocaml-gettext/releases/download/v${version}/gettext-${version}.tbz";
      hash = "sha256-CN2d9Vsq8YOOIxK+S+lCtDddvBjCrtDKGSRIh1DjT10=";
    };
    # Disable dune sites
    # See https://github.com/gildor478/ocaml-gettext/pull/37
    patches = fetchpatch {
      url = "https://github.com/gildor478/ocaml-gettext/commit/5462396bee53cb13d8d6fde4c6d430412a17b64d.patch";
      hash = "sha256-tOR+xgZTadvNeQpZnFTJEvZglK8P+ySvYnE3c1VWvKQ=";
    };
  };

  nativeBuildInputs = [ cppo ];

  propagatedBuildInputs = [
    gettext
    fileutils
  ];

  # Tests of version 0.5.0 fail
  doCheck = false;

  checkInputs = [ ounit2 ];

  meta = with lib; {
    description = "OCaml Bindings to gettext";
    homepage = "https://github.com/gildor478/ocaml-gettext";
    license = licenses.lgpl21;
    maintainers = [ ];
    mainProgram = "ocaml-gettext";
  };
}
