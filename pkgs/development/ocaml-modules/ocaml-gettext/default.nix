{
  lib,
  fetchurl,
  fetchpatch,
  applyPatches,
  buildDunePackage,
  ocaml,
  cppo,
  gettext,
  fileutils,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "gettext";
  version = "0.5.0";

  src = applyPatches {
    src = fetchurl {
      url = "https://github.com/gildor478/ocaml-gettext/releases/download/v${finalAttrs.version}/gettext-${finalAttrs.version}.tbz";
      hash = "sha256-CN2d9Vsq8YOOIxK+S+lCtDddvBjCrtDKGSRIh1DjT10=";
    };
    patches = [
      # Disable dune sites
      # See https://github.com/gildor478/ocaml-gettext/pull/37
      (fetchpatch {
        url = "https://github.com/gildor478/ocaml-gettext/commit/5462396bee53cb13d8d6fde4c6d430412a17b64d.patch";
        hash = "sha256-tOR+xgZTadvNeQpZnFTJEvZglK8P+ySvYnE3c1VWvKQ=";
      })
    ]
    # Compatibility with OCaml ≥ 5.4
    # See https://github.com/gildor478/ocaml-gettext/pull/41
    ++ lib.optional (lib.versionAtLeast ocaml.version "5.4") (fetchpatch {
      url = "https://github.com/gildor478/ocaml-gettext/commit/5d521981e39dcaeada6bbe7b15c5432d6de5d33c.patch";
      hash = "sha256-82ajmpyXSd2RdVq/ND4lS8PIugRSkKe5oL8BL9CsLo4=";
    });
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
})
