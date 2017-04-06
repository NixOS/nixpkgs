{ stdenv, fetchFromGitHub, ocaml, findlib }:

let param = {
  "4.02" = {
    version = "5.0+4.02.0";
    sha256 = "16drjk0qafjls8blng69qiv35a84wlafpk16grrg2i3x19p8dlj8"; };
  "4.03" = {
    version = "5.0+4.03.0";
    sha256 = "061v1fl5z7z3ywi4ppryrlcywnvnqbsw83ppq72qmkc7ma4603jg"; };
  "4.04" = {
    version = "unstable-20161114";
    rev = "49c08e2e4ea8fef88692cd1dcc1b38a9133f17ac";
    sha256 = "0ywzfkf5brj33nwh49k9if8x8v433ral25f3nbklfc9vqr06zrfl"; };
  "4.05" = {
    version = "5.0+4.05.0";
    sha256 = "1jvvhk6wnkvm7b9zph309ihsc0hyxfpahmxxrq19vx8c674jsdm4"; };
}."${ocaml.meta.branch}";
in
  stdenv.mkDerivation {
    name = "ocaml${ocaml.version}-ppx_tools-${param.version}";
    src = fetchFromGitHub {
      owner = "alainfrisch";
      repo = "ppx_tools";
      rev = if param ? rev then param.rev else param.version;
      inherit (param) sha256;
    };

    buildInputs = [ ocaml findlib ];

    createFindlibDestdir = true;

    dontStrip = true;

    meta = with stdenv.lib; {
      description = "Tools for authors of ppx rewriters";
      homepage = http://www.lexifi.com/ppx_tools;
      license = licenses.mit;
      platforms = ocaml.meta.platforms or [];
      maintainers = with maintainers; [ vbgl ];
    };
  }
