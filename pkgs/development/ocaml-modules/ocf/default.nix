{ stdenv, fetchFromGitHub, fetchpatch, ocaml, findlib, ppx_tools, yojson }:

if stdenv.lib.versionOlder ocaml.version "4.03"
then throw "ocf not supported for ocaml ${ocaml.version}"
else
stdenv.mkDerivation rec {
  name = "ocf-${version}";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "zoggy";
    repo = "ocf";
    rev = "release-${version}";
    sha256 = "1fhq9l2nmr39hxzpavc0jssmba71nnmhsncdn4dsbh2ylv29w56y";
  };

  buildInputs = [ ocaml findlib ppx_tools ];
  propagatedBuildInputs = [ yojson ];

  createFindlibDestdir = true;

  dontStrip = true;

  patches = [(fetchpatch {
    url = "https://github.com/zoggy/ocf/commit/3a231c7a6c5e535a77c25e207af8952793436444.patch";
    sha256 = "0nc8cggc5gxhch9amaz3s71lxs1xbgi7fs9p90cng04dsgr64xk5";
  })
  ];

  meta = with stdenv.lib; {
    description = "OCaml library to read and write configuration options in JSON syntax";
    homepage = https://zoggy.github.io/ocf/;
    license = licenses.lgpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ regnat ];
  };
}
