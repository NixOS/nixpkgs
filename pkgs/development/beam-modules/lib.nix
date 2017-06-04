{ pkgs }:

rec {

  /* Uses generic-builder to evaluate provided drv containing OTP-version specific data.

  drv: package containing version-specific args;
  builder: generic builder for all Erlang versions;
  gargs: arguments passed to the generic-builder, used mostly to customize dependencies;
  args: arguments merged into version-specific args, used mostly to enable/disable high-level OTP
    features, like ODBC or WX support;

  Please note that "mkDerivation" defined here is the one called from R16.nix and similar files.
  */
  callErlang = drv: gargs: args: pkgs.callPackage drv (
    let builder = pkgs.callPackage ../../development/interpreters/erlang/generic-builder.nix gargs;
    in {
      mkDerivation = a: builder (a // args);
    });

}
