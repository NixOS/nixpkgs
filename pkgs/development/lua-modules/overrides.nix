{ pkgs,  ... }@args:
self: super:
with super;
{
  ##########################################3
  #### manual fixes for generated packages
  ##########################################3

  lgi = super.lgi.overrideAttrs(oa: {
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with pkgs; oa.buildInputs ++  [ glib gobjectIntrospection];
    patches = [
        (pkgs.fetchpatch {
            name = "lgi-find-cairo-through-typelib.patch";
            url = "https://github.com/psychon/lgi/commit/46a163d9925e7877faf8a4f73996a20d7cf9202a.patch";
            sha256 = "0gfvvbri9kyzhvq3bvdbj2l6mwvlz040dk4mrd5m9gz79f7w109c";
        })
    ];
  });

  ltermbox = super.ltermbox.override( {
    disabled = !isLua51 || isLuaJIT;
  });

  luazip = super.luazip.overrideAttrs(old: {
    buildInputs = old.buildInputs ++ [ pkgs.zziplib ];
  });

  lua-cmsgpack = super.lua-cmsgpack.override({
    # TODO this should work with luajit once we fix luajit headers ?
    disabled = (!isLua51) || isLuaJIT;
  });

  luazlib = lua-zlib;
  lua-zlib = super.lua-zlib.override({
    buildInputs = [ pkgs.zlib.dev ];
    disabled = luaOlder "5.1" || luaAtLeast "5.4";
  });

  lua-iconv = super.lua-iconv.override({
    buildInputs = [ pkgs.libiconv ];
    disabled = !isLua51;
  });
  luaexpat = super.luaexpat.override({
    buildInputs = [ pkgs.expat.dev ];
    disabled = isLuaJIT;
  });
  luaevent = super.luaevent.override({
    buildInputs = with pkgs; [ libevent.dev libevent ];
    extraConfig = with pkgs; ''
      variables={
        EVENT_INCDIR="${libevent.dev}/include";
        EVENT_LIBDIR="${libevent}/lib";
      }
      '';
    disabled = luaOlder "5.1" || luaAtLeast "5.4" || isLuaJIT;
  });
  lrexlib-posix = super.lrexlib-posix.override({
    buildInputs = [ pkgs.glibc.dev ];
  });
  lrexlib-gnu = super.lrexlib-gnu.override({
    buildInputs = [ pkgs.gnulib ];
  });
  lua-cjson = super.lua-cjson.override({
    disabled = isLuaJIT;
  });
  cjson = lua-cjson;
  luadbi = super.luadbi.override({
    buildInputs = with pkgs; [ mysql.connector-c postgresql sqlite ];
  });
  luasec = super.luasec.override({
    extraConfig = with pkgs; ''
      variables={
        OPENSSL_INCDIR="${openssl.dev}/include";
        OPENSSL_LIBDIR="${openssl.out}/lib";
      }
      '';
  });
  cqueues = super.cqueues.override({
    nativeBuildInputs = [ pkgs.gnum4 ];
    buildInputs = [ pkgs.openssl ];
    extraConfig = with pkgs; ''
      variables={
        CRYPTO_INCDIR="${openssl.dev}/include";
        CRYPTO_LIBDIR="${openssl.out}/lib";
        OPENSSL_INCDIR="${openssl.dev}/include";
        OPENSSL_LIBDIR="${openssl.out}/lib";
      }
      '';
  });

  luv = super.luv.overrideAttrs(oa: {
    propagatedBuildInputs = oa.propagatedBuildInputs ++ [ pkgs.libuv ];
  });

  busted = super.busted.overrideAttrs(oa: {
    postInstall = ''
      install -D completions/zsh/_busted $out/share/zsh/site-functions/_busted
    '';
  });

  # for backwards compatibility
  std._debug = super.std__debug;
  std._normalize = super.std__normalize;
 }
