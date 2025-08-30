{
  lib,
  buildDunePackage,
  camlp5,
  ocaml,
  menhir,
  menhirLib,
  atdgen,
  atdgen-runtime,
  stdlib-shims,
  re,
  perl,
  ncurses,
  ppx_deriving,
  ppx_deriving_0_15,
  coqPackages,
  version ?
    if lib.versionAtLeast ocaml.version "4.13" then
      "3.0.1"
    else if lib.versionAtLeast ocaml.version "4.08" then
      "1.20.0"
    else
      "1.15.2",
}:

let
  p5 = camlp5;
in
let
  camlp5 = p5.override { legacy = true; };
in

let
  fetched = coqPackages.metaFetch ({
    release."3.0.1".hash = "sha256-UY1Xti4i6RY9Xh+6T9Uxdoul02/ndvIN1e2eClwegPU=";
    release."2.0.7".hash = "sha256-ccixsjyW8RH1CgE2iv//cYrGnQCKFL//KLCGIGER3Rs=";
    release."2.0.6".hash = "sha256-DOBfFe9a7Mk+gqvi3Gy3N86C48TGvpeGNie/Ff3O7Ic=";
    release."2.0.5".hash = "sha256-UfFoDQM5ImYPRw3XFjKLU+zu4bEkHXatg6sbkfJHw3s=";
    release."2.0.3".hash = "sha256-s1cYZsxVWQQfJsqHXUOGbT7PnX5ngq8rjm7mO++A+Tk=";
    release."1.20.0".hash = "sha256-7d+5W4t40qERnbJYrY/X63EriIQ+p8WMahV8XleMk0o=";
    release."1.19.2".hash = "sha256-B9ppaWUTBxpVtJGsPYoLjWhbtGacFTVC5H+7fqm+pj8=";
    release."1.18.2".hash = "sha256-cmEs/N7+Ir7G0pUD3pFEjkeO9hI6qO8lDv4ua9NuzTU=";
    release."1.18.1".hash = "sha256-NgRCFgzxOM7MCpMdnwxY/yYcoA8WKo+ZJrKJy1bWo0U=";
    release."1.17.0".hash = "sha256-4EEXQSnYtaX2YT3t5EIT0yVZYAkx/UW7tGeUOzn+anM=";
    release."1.15.2".hash = "sha256-TAWdtjbJcpVxog3urBiWlPzsK9gscKSmma/si48F4sk=";
    release."1.15.0".hash = "sha256-HUHnRF9BfsgmOQXI14HP0I4yE+qiXJPZedFhECzhbDA=";
    release."1.13.7".hash = "sha256-/m4q9SrjBxiP8tPnGymxPHGL+/e29kalb3TMLmDge+A=";
    release."1.12.0".hash = "sha256-QmpqyKi0/9xTe/TNZg0z2gRPifc1k1U/L/W2yRwXo38=";
    release."1.11.4".hash = "sha256-gZ1KPMaAe0+ABYo38drsMoQuky1EzgYh3ydIUb64ssI=";
    releaseRev = v: "v${v}";
    releaseArtifact = v: if lib.versionAtLeast v "1.13.8" then "elpi-${v}.tbz" else "elpi-v${v}.tbz";
    location = {
      domain = "github.com";
      owner = "LPCIC";
      repo = "elpi";
    };
  }) version;
in
let
  inherit (fetched) version;
in
buildDunePackage {
  pname = "elpi";
  inherit version;
  inherit (fetched) src;

  patches = lib.optional (version == "1.16.5") ./atd_2_10.patch;

  minimalOCamlVersion = "4.07";

  nativeBuildInputs = [
    perl
  ]
  ++ [ (if lib.versionAtLeast version "1.15" || version == "dev" then menhir else camlp5) ]
  ++ lib.optional (lib.versionAtLeast version "1.16" || version == "dev") atdgen;
  buildInputs = [
    ncurses
  ]
  ++ lib.optional (lib.versionAtLeast version "1.16" || version == "dev") atdgen-runtime;

  propagatedBuildInputs = [
    re
    stdlib-shims
  ]
  ++ (if lib.versionAtLeast version "1.15" || version == "dev" then [ menhirLib ] else [ camlp5 ])
  ++ (
    if lib.versionAtLeast version "1.13" || version == "dev" then
      [
        ppx_deriving
      ]
    else
      [
        ppx_deriving_0_15
      ]
  );

  meta = with lib; {
    description = "Embeddable λProlog Interpreter";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.vbgl ];
    homepage = "https://github.com/LPCIC/elpi";
  };

  postPatch = ''
    substituteInPlace elpi_REPL.ml --replace-warn "tput cols" "${ncurses}/bin/tput cols"
  ''
  + lib.optionalString (lib.versionAtLeast version "1.16" || version == "dev") ''
    substituteInPlace src/dune --replace-warn ' atdgen re' ' atdgen-runtime re'
  '';
}
