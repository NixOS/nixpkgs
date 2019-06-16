{ pkgs,  ... }:
self: super:
with super;
{
  ##########################################3
  #### manual fixes for generated packages
  ##########################################3
  lgi = super.lgi.overrideAttrs(oa: {
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with pkgs; oa.buildInputs ++ [ glib gobjectIntrospection];
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
  lua-zlib = super.lua-zlib.override({
    buildInputs = [ pkgs.zlib.dev ];
    disabled=luaOlder "5.1" || luaAtLeast "5.4";
  });
  luaevent = super.luaevent.override({
    buildInputs = with pkgs; [ libevent.dev libevent ];
    propagatedBuildInputs = [ luasocket ];
    extraConfig = ''
      variables={
        EVENT_INCDIR="${pkgs.libevent.dev}/include";
        EVENT_LIBDIR="${pkgs.libevent}/lib";
      }
    '';
    disabled= luaOlder "5.1" || luaAtLeast "5.4" || isLuaJIT;
  });
  lua-iconv = super.lua-iconv.override({
    buildInputs = [ pkgs.libiconv ];
  });
  luazip = super.luazip.override({
    buildInputs = [ pkgs.zziplib ];
  });
  luv = super.luv.overrideAttrs(oa: {
    # Use system libuv instead of building local and statically linking
    # This is a hacky way to specify -DWITH_SHARED_LIBUV=ON which
    # should be possible but I'm unable to make work.
    # While at it, remove bundled libuv source entirely to be sure.
    # We may wish to drop bundled lua submodules too...
    preBuild = ''
     sed -i 's,\(option(WITH_SHARED_LIBUV.*\)OFF,\1ON,' CMakeLists.txt
     rm -rf deps/libuv
    '';
    propagatedBuildInputs = oa.propagatedBuildInputs ++ [ pkgs.libuv ];
  });

  busted = super.busted.overrideAttrs(oa: {
    postInstall = ''
      install -D completions/zsh/_busted $out/share/zsh/site-functions/_busted
    '';
  });

  luuid = super.luuid.override(oa: {
    buildInputs = [ pkgs.libuuid ];
    extraConfig = ''
      variables = {
        LIBUUID_INCDIR="${pkgs.lib.getDev pkgs.libuuid}/include";
        LIBUUID_LIBDIR="${pkgs.lib.getLib pkgs.libuuid}/lib";
      }
    '';
    meta = oa.meta // {
      platforms = pkgs.lib.platforms.linux;
    };
  });

  rapidjson = super.rapidjson.overrideAttrs(oa: {
    preBuild = ''
      sed -i '/set(CMAKE_CXX_FLAGS/d' CMakeLists.txt
      sed -i '/set(CMAKE_C_FLAGS/d' CMakeLists.txt
    '';
  });

  binaryheap = super.binaryheap.overrideAttrs(oa: {
    meta = oa.meta // {
      maintainers = with pkgs.lib.maintainers; oa.meta.maintainers ++ [ vcunat ];
    };
  });

  http = super.http.overrideAttrs(oa: {
    patches = oa.patches or [] ++ [
      (pkgs.fetchpatch {
        name = "invalid-state-progression.patch";
        url = "https://github.com/daurnimator/lua-http/commit/cb7b59474a.diff";
        sha256 = "1vmx039n3nqfx50faqhs3wgiw28ws416rhw6vh6srmh9i826dac7";
      })
    ];
    /* TODO: separate docs derivation? (pandoc is heavy)
    nativeBuildInputs = [ pandoc ];
    makeFlags = [ "-C doc" "lua-http.html" "lua-http.3" ];
    */
    meta = oa.meta // {
      maintainers = with pkgs.lib.maintainers; oa.meta.maintainers ++ [ vcunat ];
    };
  });
}
