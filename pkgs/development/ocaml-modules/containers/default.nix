{ stdenv, fetchFromGitHub, ocaml, findlib, cppo, gen, sequence, qtest, ounit, ocaml_oasis, result }:

let

  mkpath = p:
    let v = stdenv.lib.getVersion ocaml; in
      "${p}/lib/ocaml/${v}/site-lib";

  version = "0.16";

in

stdenv.mkDerivation {
  name = "ocaml-containers-${version}";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-containers";
    rev = "${version}";
    sha256 = "1mc33b4nvn9k3r4k56amxr804bg5ndhxv92cmjzg5pf4qh220c2h";
  };

  buildInputs = [ ocaml findlib cppo gen sequence qtest ounit ocaml_oasis ];

  propagatedBuildInputs = [ result ];

  preConfigure = ''
    # The following is done so that the '#use "topfind"' directive works in the ocaml top-level
    export HOME="$(mktemp -d)"
    export OCAML_TOPLEVEL_PATH="${mkpath findlib}"
    cat <<EOF > $HOME/.ocamlinit
let () =
  try Topdirs.dir_directory (Sys.getenv "OCAML_TOPLEVEL_PATH")
  with Not_found -> ()
;;
EOF
  '';

  configureFlags = [
    "--enable-unix"
    "--enable-thread"
    "--enable-bigarray"
    "--enable-advanced"
    "--enable-tests"
    "--disable-bench"
  ];

  doCheck = true;
  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/c-cube/ocaml-containers;
    description = "A modular standard library focused on data structures";
    longDescription = ''
      Containers is a standard library (BSD license) focused on data structures,
      combinators and iterators, without dependencies on unix. Every module is
      independent and is prefixed with 'CC' in the global namespace. Some modules
      extend the stdlib (e.g. CCList provides safe map/fold_right/append, and
      additional functions on lists).

      It also features optional libraries for dealing with strings, and
      helpers for unix and threads.
    '';
    license = stdenv.lib.licenses.bsd2;
    platforms = ocaml.meta.platforms or [];
  };
}
