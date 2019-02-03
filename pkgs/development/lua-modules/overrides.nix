{ pkgs,  ... }@args:
self: super:
with super;
{
  ##########################################3
  #### manual fixes for generated packages
  ##########################################3

  ltermbox = super.ltermbox.override( {
    disabled = !isLua51 || isLuaJIT;
  });

  lua-cmsgpack = super.lua-cmsgpack.override({
    # TODO this should work with luajit once we fix luajit headers ?
    disabled = (!isLua51) || isLuaJIT;
  });

  lrexlib-posix = super.lrexlib-posix.override({
    buildInputs = [ pkgs.glibc.dev ];
  });
  lrexlib-gnu = super.lrexlib-gnu.override({
    buildInputs = [ pkgs.gnulib ];
  });
  luv = super.luv.overrideAttrs(oa: {
    propagatedBuildInputs = oa.propagatedBuildInputs ++ [ pkgs.libuv ];
  });

  busted = super.busted.overrideAttrs(oa: {
    postInstall = ''
      install -D completions/zsh/_busted $out/share/zsh/site-functions/_busted
    '';
  });
 }
