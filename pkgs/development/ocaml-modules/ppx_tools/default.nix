{ stdenv, fetchFromGitHub, ocaml, findlib }:

let param = {
  "4.02.3" = {
    version = "5.0+4.02.0";
    sha256 = "16drjk0qafjls8blng69qiv35a84wlafpk16grrg2i3x19p8dlj8"; };
  "4.03.0" = {
    version = "5.0+4.03.0";
    sha256 = "061v1fl5z7z3ywi4ppryrlcywnvnqbsw83ppq72qmkc7ma4603jg"; };
}."${ocaml.version}";
in
  stdenv.mkDerivation {
    name = "ocaml${ocaml.version}-ppx_tools-${param.version}";
    src = fetchFromGitHub {
      owner = "alainfrisch";
      repo = "ppx_tools";
      rev = param.version;
      inherit (param) sha256;
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
