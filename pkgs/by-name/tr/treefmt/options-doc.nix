# To build this derivation, run `nix-build -A treefmt.optionsDoc`
{
  lib,
  treefmt,
  nixosOptionsDoc,
}:

let
  configuration = treefmt.evalConfig [ ];

  root = toString configuration._module.specialArgs.modulesPath;
  revision = lib.trivial.revisionWithDefault "master";
  removeRoot = file: lib.removePrefix "/" (lib.removePrefix root file);

  transformDeclaration =
    file:
    let
      fileStr = toString file;
      subpath = "pkgs/by-name/tr/treefmt/modules/" + removeRoot fileStr;
    in
    assert lib.hasPrefix root fileStr;
    {
      url = "https://github.com/NixOS/nixpkgs/blob/${revision}/${subpath}";
      name = subpath;
    };
in
nixosOptionsDoc {
  options = removeAttrs configuration.options [ "_module" ];
  transformOptions = opt: opt // { declarations = map transformDeclaration opt.declarations; };
}
