{ stdenv
, pkgs
, lib
, ...
} :
let

name = "xnode-personaliser";
version = "v0.0.0-0xnodepkgs0";

src = pkgs.fetchFromGitHub {
  owner = "Openmesh-Network";
  repo = name;
  rev = "161b76f2ac140a414e230513aedba9d29cbb4a20";
  sha256 = "sha256-CveaUIvkyrbSFuRP78k9fk1uSgUvf6SlbXvm1VlPIF4=";
};

inputs = with pkgs; [ jq curl gnugrep ];

script = ( pkgs.writeScriptBin name (
    builtins.readFile "${src}/src/xnode-personaliser.sh"
    )
  ).overrideAttrs(old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });

in

pkgs.symlinkJoin {
  name = name;
  version = version;

  buildInputs = [ pkgs.makeWrapper ];

  paths = [ script ]  ++ inputs;

  postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";

  meta = with lib; {
    homepage = "https://openmesh.network/";
    description = "Installs a simple script that takes a script from any applicable personalisation interface (kernel cmdline base64/etc) and provides a well defined runtime environment.";
    mainProgram = name;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ j-openmesh ];
  };
}
