{ stdenv, fetchFromGitHub, buildDunePackage, cppo, bos, cmdliner, tyxml }:

buildDunePackage rec {
  pname = "odoc";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = version;
    sha256 = "0hjan5aj5zk8j8qyagv9r4hqm469mh207cv2m6kxwgnw0c3cz7sy";
  };

  buildInputs = [ cppo bos cmdliner tyxml ];

  meta = {
    description = "A documentation generator for OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
