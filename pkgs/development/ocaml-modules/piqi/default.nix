{ lib, stdenv, fetchFromGitHub, ocaml, findlib, which, sedlex, easy-format, xmlm, base64 }:

stdenv.mkDerivation rec {
  version = "0.6.15";
  pname = "piqi";
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "alavrik";
    repo = pname;
    rev = "v${version}";
    sha256 = "0v04hs85xv6d4ysqxyv1dik34dx49yab9shpi4x7iv19qlzl7csb";
  };

  nativeBuildInputs = [ ocaml findlib which ];
  propagatedBuildInputs = [ sedlex xmlm easy-format base64 ];

  strictDeps = true;

  patches = [ ./no-ocamlpath-override.patch ];

  createFindlibDestdir = true;

  postBuild = "make -C piqilib piqilib.cma";

  installTargets = [ "install" "ocaml-install" ];

  meta = with lib; {
    homepage = "https://piqi.org";
    description = "Universal schema language and a collection of tools built around it";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer ];
  };
}
