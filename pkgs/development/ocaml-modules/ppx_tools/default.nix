{ lib, stdenv, fetchFromGitHub, buildDunePackage, ocaml, findlib, cppo }:

let param =
  let v6_6 = {
    version = "6.6";
    sha256 = "sha256-QhuaQ9346a3neoRM4GrOVzjR8fg9ysMZR1VzNgyIQtc=";
    nativeBuildInputs = [cppo];
    buildInputs = [cppo];
  }; in
{
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
  "4.06" = {
    version = "5.1+4.06.0";
    sha256 = "1ww4cspdpgjjsgiv71s0im5yjkr3544x96wsq1vpdacq7dr7zwiw"; };
  "4.07" = {
    version = "5.1+4.06.0";
    sha256 = "1ww4cspdpgjjsgiv71s0im5yjkr3544x96wsq1vpdacq7dr7zwiw"; };
  "4.08" = v6_6;
  "4.09" = v6_6;
  "4.10" = v6_6;
  "4.11" = v6_6;
  "4.12" = v6_6;
  "4.13" = v6_6;
  "4.14" = v6_6;
  "5.0" = v6_6;
}.${ocaml.meta.branch};
in

let src = fetchFromGitHub {
      owner = "alainfrisch";
      repo = pname;
      rev = param.rev or param.version;
      inherit (param) sha256;
    };
    pname = "ppx_tools";
    meta = with lib; {
      description = "Tools for authors of ppx rewriters";
      homepage = "https://www.lexifi.com/ppx_tools";
      license = licenses.mit;
      maintainers = with maintainers; [ vbgl ];
    };
in
if lib.versionAtLeast param.version "6.0"
then
  buildDunePackage {
    inherit pname src meta;
    inherit (param) version buildInputs nativeBuildInputs;
    duneVersion = "3";

    strictDeps = true;
  }
else
  stdenv.mkDerivation {
    name = "ocaml${ocaml.version}-${pname}-${param.version}";

    inherit src;

    nativeBuildInputs = [ ocaml findlib ];

    strictDeps = true;

    createFindlibDestdir = true;

    dontStrip = true;

    meta = meta // { inherit (ocaml.meta) platforms; };
  }
