{ pkgs, ... }@args:
self: super:
# can't we do without the rec ? there ?
# in haskell/configuration-common. il y a haskellLib instead
with self; with pkgs;
# TODO
{
  ##########################################3
  #### fixes for generated packages
  ##########################################3
  # TODO include this only when super exist ?

  lgi = super.lgi.overrideAttrs(oa: {
    nativeBuildInputs = [ pkgconfig ];
    buildInputs = oa.buildInputs ++ [ glib gobjectIntrospection];
    patches = [
        (fetchpatch {
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
    buildInputs = old.buildInputs ++ [ zziplib ];
  });

  lua-cmsgpack = super.lua-cmsgpack.override({
    # TODO this should work with luajit once we fix luajit headers ?
    # TODO won't work, the disabled needs to be be on the override
    disabled = (!isLua51) || isLuaJIT;
  });

  luazlib=lua-zlib;
  lua-zlib = super.lua-zlib.override({
    buildInputs = [ pkgs.zlib.dev ];
    disabled=luaOlder "5.1" || luaAtLeast "5.4";
  });

  lua-iconv = super.lua-iconv.override({
    buildInputs = [ libiconv ];
    disabled=!isLua51;
  });
  luaexpat = super.luaexpat.override({
    buildInputs = [ expat.dev ];
    disabled=isLuaJIT;
  });
  luaevent = super.luaevent.override({
    buildInputs = [ libevent.dev libevent ];
    extraConfig=''
      variables={
        EVENT_INCDIR="${libevent.dev}/include";
        EVENT_LIBDIR="${libevent}/lib";
      }
      '';
    disabled= luaOlder "5.1" || luaAtLeast "5.4" || isLuaJIT;
  });
  lrexlib-posix = super.lrexlib-posix.override({
    buildInputs = [ glibc.dev ];
  });
  lrexlib-gnu = super.lrexlib-gnu.override({
    buildInputs = [ gnulib ];
  });
  lua-cjson = super.lua-cjson.override({
    disabled=isLuaJIT;
  });
  cjson = lua-cjson;
  luadbi = super.luadbi.override({
    buildInputs = [ mysql.connector-c postgresql sqlite ];
  });
  luasec = super.luasec.override({
    extraConfig=''
      variables={
        OPENSSL_INCDIR="${openssl.dev}/include";
        OPENSSL_LIBDIR="${openssl.out}/lib";
      }
      '';
  });
  cqueues = super.cqueues.override({
    nativeBuildInputs = [ gnum4 ];
    buildInputs = [ openssl ];
    extraConfig=''
      variables={
        CRYPTO_INCDIR="${openssl.dev}/include";
        CRYPTO_LIBDIR="${openssl.out}/lib";
        OPENSSL_INCDIR="${openssl.dev}/include";
        OPENSSL_LIBDIR="${openssl.out}/lib";
      }
      '';
  });

  luv = super.luv.overrideAttrs(oa: {
    propagatedBuildInputs = oa.propagatedBuildInputs ++ [pkgs.libuv ];
    # deps/lua-compat-5.3/rockspecs/compat53-0.5-1.rockspec
    # rockspecFilename = "deps/lua-compat-5.3/rockspecs/compat53-scm-0.rockspec";
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
