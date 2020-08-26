{ lib, fetchFromGitHub, fetchpatch, buildDunePackage
, base64, bos, core, lwt_react, ocamlgraph, rresult, tyxml
}:

buildDunePackage rec {
  pname = "bistro";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "pveber";
    repo = pname;
    rev = "v${version}";
    sha256 = "114gq48cpj2mvycypa9lfyqqb26wa2gkdfwkcqhnx7m6sdwv9a38";
  };

  # The following patch adds support for core.v0.13
  patches = [(fetchpatch {
    url = "https://github.com/pveber/bistro/commit/0931db43a146ad7829dff5120161a775f732a878.patch";
    sha256 = "06y0sxbbab1mssc1xfjjv12lpv4rny5iqv9qkdqyzrvzpl1bdvnd";
  })];

  propagatedBuildInputs = [ base64 bos core lwt_react ocamlgraph rresult tyxml ];

  minimumOCamlVersion = "4.07";

  meta = {
    inherit (src.meta) homepage;
    description = "Build and execute typed scientific workflows";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.gpl2;
  };
}
