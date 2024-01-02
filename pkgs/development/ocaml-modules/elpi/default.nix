{ lib
, buildDunePackage, camlp5
, ocaml
, menhir, menhirLib
, atdgen
, stdlib-shims
, re, perl, ncurses
, ppxlib, ppx_deriving
, ppxlib_0_15, ppx_deriving_0_15
, coqPackages
, version ? if lib.versionAtLeast ocaml.version "4.08" then "1.17.0"
    else if lib.versionAtLeast ocaml.version "4.07" then "1.15.2" else "1.14.1"
}:

let p5 = camlp5; in
let camlp5 = p5.override { legacy = true; }; in

let fetched = coqPackages.metaFetch ({
    release."1.17.0".sha256 = "sha256-DTxE8CvYl0et20pxueydI+WzraI6UPHMNvxyp2gU/+w=";
    release."1.16.5".sha256 = "sha256-tKX5/cVPoBeHiUe+qn7c5FIRYCwY0AAukN7vSd/Nz9A=";
    release."1.15.2".sha256 = "sha256-XgopNP83POFbMNyl2D+gY1rmqGg03o++Ngv3zJfCn2s=";
    release."1.15.0".sha256 = "sha256:1ngdc41sgyzyz3i3lkzjhnj66gza5h912virkh077dyv17ysb6ar";
    release."1.14.1".sha256 = "sha256-BZPVL8ymjrE9kVGyf6bpc+GA2spS5JBpkUtZi04nPis=";
    release."1.13.7".sha256 = "10fnwz30bsvj7ii1vg4l1li5pd7n0qqmwj18snkdr5j9gk0apc1r";
    release."1.13.5".sha256 = "02a6r23mximrdvs6kgv6rp0r2dgk7zynbs99nn7lphw2c4189kka";
    release."1.13.1".sha256 = "12a9nbdvg9gybpw63lx3nw5wnxfznpraprb0wj3l68v1w43xq044";
    release."1.13.0".sha256 = "0dmzy058m1mkndv90byjaik6lzzfk3aaac7v84mpmkv6my23bygr";
    release."1.12.0".sha256 = "1agisdnaq9wrw3r73xz14yrq3wx742i6j8i5icjagqk0ypmly2is";
    release."1.11.4".sha256 = "1m0jk9swcs3jcrw5yyw5343v8mgax238cjb03s8gc4wipw1fn9f5";
    releaseRev = v: "v${v}";
    location = { domain = "github.com"; owner = "LPCIC"; repo = "elpi"; };
  }) version;
in
buildDunePackage rec {
  pname = "elpi";
  inherit (fetched) version src;

  patches = lib.optional (version == "1.16.5")
    ./atd_2_10.patch;

  minimalOCamlVersion = "4.04";
  duneVersion = "3";

  # atdgen is both a library and executable
  nativeBuildInputs = [ perl ]
  ++ [ (if lib.versionAtLeast version "1.15" || version == "dev" then menhir else camlp5) ]
  ++ lib.optional (lib.versionAtLeast version "1.16" || version == "dev") atdgen;
  buildInputs = [ ncurses ]
  ++ lib.optional (lib.versionAtLeast version "1.16" || version == "dev") atdgen;

  propagatedBuildInputs = [ re stdlib-shims ]
  ++ (if lib.versionAtLeast version "1.15" || version == "dev"
     then [ menhirLib ]
     else [ camlp5 ]
  )
  ++ (if lib.versionAtLeast version "1.13" || version == "dev"
     then [ ppxlib ppx_deriving ]
     else [ ppxlib_0_15 ppx_deriving_0_15 ]
  );

  meta = with lib; {
    description = "Embeddable λProlog Interpreter";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.vbgl ];
    homepage = "https://github.com/LPCIC/elpi";
  };

  postPatch = ''
    substituteInPlace elpi_REPL.ml --replace "tput cols" "${ncurses}/bin/tput cols"
  '';
}
