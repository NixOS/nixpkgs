{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  js_of_ocaml,
  lwt_ppx,
  lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "ocsipersist-lib";
  version = "2.1.0";

  minimalOCamlVersion = "4.13";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsipersist";
    tag = finalAttrs.version;
    hash = "sha256-YJzfgeyNXgBXAK607ROUXUmSpMKYx63ofZaBB8dnsq4=";
  };

  buildInputs = [ lwt_ppx ];
  propagatedBuildInputs = [
    js_of_ocaml
    lwt
  ];

  meta = {
    description = "Persistent key/value storage (for Ocsigen) - support library";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/ocsigen/ocsipersist/";
  };
})
