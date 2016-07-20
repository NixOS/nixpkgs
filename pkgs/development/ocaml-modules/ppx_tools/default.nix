{ stdenv, fetchFromGitHub, ocaml, findlib }:

let
  version =
  if stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.03" then "5.0+4.03.0" else "5.0+4.02.0";
in
  stdenv.mkDerivation {
    name = "ocaml-ppx_tools-${version}";
    src = fetchFromGitHub {
      owner = "alainfrisch";
      repo = "ppx_tools";
      rev = version;
      sha256 = if version == "5.0+4.03.0"
      then "061v1fl5z7z3ywi4ppryrlcywnvnqbsw83ppq72qmkc7ma4603jg"
      else "16drjk0qafjls8blng69qiv35a84wlafpk16grrg2i3x19p8dlj8"
      ;
    };

    buildInputs = [ ocaml findlib ];

    createFindlibDestdir = true;

    meta = with stdenv.lib; {
      description = "Tools for authors of ppx rewriters";
      homepage = http://www.lexifi.com/ppx_tools;
      license = licenses.mit;
      platforms = ocaml.meta.platforms or [];
      maintainers = with maintainers; [ vbgl ];
    };
  }
