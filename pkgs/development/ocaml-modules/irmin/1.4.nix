{ stdenv, fetchFromGitHub, buildDunePackage, ocaml
, astring, cstruct, fmt, hex, jsonm, logs, ocaml_lwt, ocamlgraph, uri
}:

buildDunePackage rec {
  pname = "irmin";
  version = "1.4.0";

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = pname;
    rev = version;
    sha256 = "0f272h9d0hs0wn5m30348wx7vz7524yk40wx5lx895vv3r3p7q7c";
  };

  propagatedBuildInputs = [ astring cstruct fmt hex jsonm logs ocaml_lwt ocamlgraph uri ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/irmin;
    description = "Irmin, a distributed database that follows the same design principles as Git";
    license = licenses.isc;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.alexfmpe ];
  };
}
