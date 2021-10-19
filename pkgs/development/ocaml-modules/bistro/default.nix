{ lib, fetchFromGitHub, fetchpatch, buildDunePackage
, base64, bos, core, lwt_react, ocamlgraph, rresult, tyxml
}:

buildDunePackage rec {
  pname = "bistro";
  version = "0.5.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "pveber";
    repo = pname;
    rev = "v${version}";
    sha256 = "114gq48cpj2mvycypa9lfyqqb26wa2gkdfwkcqhnx7m6sdwv9a38";
  };

  patches = [
  # The following patch adds support for core.v0.13
  (fetchpatch {
    url = "https://github.com/pveber/bistro/commit/0931db43a146ad7829dff5120161a775f732a878.patch";
    sha256 = "06y0sxbbab1mssc1xfjjv12lpv4rny5iqv9qkdqyzrvzpl1bdvnd";
  })
  # The following patch adds support for core.v0.14
  (fetchpatch {
    url = "https://github.com/pveber/bistro/commit/afbdcb2af7777ef7711c7f3c45dff605350a27b2.patch";
    sha256 = "0ix6lx9qjnn3vqp0164c6l5an8b4rq69h2mxrg89piyk2g1yv0zg";
  })
  ];

  # Fix build with ppxlib 0.23
  postPatch = ''
    substituteInPlace ppx/ppx_bistro.ml \
      --replace 'Parser.parse_expression' 'Ocaml_common.Parser.parse_expression'
  '';

  propagatedBuildInputs = [ base64 bos core lwt_react ocamlgraph rresult tyxml ];

  minimalOCamlVersion = "4.12";

  meta = {
    inherit (src.meta) homepage;
    description = "Build and execute typed scientific workflows";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.gpl2;
  };
}
