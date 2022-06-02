{ stdenv, lib, fetchzip, buildDunePackage, camlp5
, re, perl, ncurses
, ppxlib, ppx_deriving
, ppxlib_0_15, ppx_deriving_0_15
, version ? "1.14.1"
}:
with lib;
let fetched = import ../../../build-support/coq/meta-fetch/default.nix
  {inherit lib stdenv fetchzip; } ({
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

  minimumOCamlVersion = "4.04";

  buildInputs = [ perl ncurses ];

  propagatedBuildInputs = [ camlp5 re ]
  ++ (if lib.versionAtLeast version "1.13"
     then [ ppxlib ppx_deriving ]
     else [ ppxlib_0_15 ppx_deriving_0_15 ]
  );

  meta = {
    description = "Embeddable λProlog Interpreter";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.vbgl ];
    homepage = "https://github.com/LPCIC/elpi";
  };

  postPatch = ''
    substituteInPlace elpi_REPL.ml --replace "tput cols" "${ncurses}/bin/tput cols"
  '';

  useDune2 = true;
}
