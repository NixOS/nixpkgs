{ stdenv, fetchFromGitHub, ocaml, buildOcaml, lib }:

let
  # The library has different releases for each version of Ocaml
  checksums = {
    "4.02.0" = "16drjk0qafjls8blng69qiv35a84wlafpk16grrg2i3x19p8dlj8";
    "4.03.0" = "061v1fl5z7z3ywi4ppryrlcywnvnqbsw83ppq72qmkc7ma4603jg";
  };
  ocamlVersion = lib.getVersion ocaml;

  # get the version corresponding to the current compiler
  variant = lib.fold (accu: cur:
    if lib.versionAtLeast ocamlVersion cur
        && lib.versionAtLeast cur accu
    then
      cur
    else accu
    )
    "0"
    (lib.mapAttrsToList (name: _: name) checksums);
in

assert (variant != "0");

buildOcaml rec {
  version = "5.0";
  name = "ppx_tools";
  src = fetchFromGitHub {
    owner = "alainfrisch";
    repo = name;
    rev = version + "+" + variant;
    sha256 = checksums."${variant}";
  };

  meta = with stdenv.lib; {
    description = "Tools for authors of ppx rewriters";
    homepage = http://www.lexifi.com/ppx_tools;
    license = licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ vbgl ];
  };
}
