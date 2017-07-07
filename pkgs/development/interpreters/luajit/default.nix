{ stdenv, fetchurl, hostPlatform }:
rec {

  luajit =
    # Compatibility problems with lightuserdata pointers; see:
    # https://github.com/LuaJIT/LuaJIT/blob/v2.1/doc/status.html#L101
    if hostPlatform.is64bit && (hostPlatform.isArm || hostPlatform.isSunOS)
      then luajit_2_0
      else luajit_2_1;

  luajit_2_0 = generic {
    version = "2.0.5";
    isStable = true;
    sha256 = "0yg9q4q6v028bgh85317ykc9whgxgysp76qzaqgq55y6jy11yjw7";
  };

  luajit_2_1 = generic {
    version = "2.1.0-beta3";
    isStable = false;
    sha256 = "1hyrhpkwjqsv54hnnx4cl8vk44h9d6c9w0fz1jfjz00w255y7lhs";
  };


  generic =
    { version, sha256 ? null, isStable
    , name ? "luajit-${version}"
    , src ?
      (fetchurl {
        url = "http://luajit.org/download/LuaJIT-${version}.tar.gz";
        inherit sha256;
      })
    }:

    stdenv.mkDerivation rec {
      inherit name version src;

      luaversion = "5.1";

      patchPhase = ''
        substituteInPlace Makefile \
          --replace /usr/local "$out"

        substituteInPlace src/Makefile --replace gcc cc
      '' + stdenv.lib.optionalString (stdenv.cc.libc != null)
      ''
        substituteInPlace Makefile \
          --replace ldconfig ${stdenv.cc.libc.bin or stdenv.cc.libc}/bin/ldconfig
      '';

      configurePhase = false;

      buildFlags = [ "amalg" ]; # Build highly optimized version
      enableParallelBuilding = true;

      installPhase   = ''
        make install INSTALL_INC="$out"/include PREFIX="$out"
        ln -s "$out"/bin/luajit-* "$out"/bin/lua
      ''
        + stdenv.lib.optionalString (!isStable)
          ''
            ln -s "$out"/bin/luajit-* "$out"/bin/luajit
          '';

      meta = with stdenv.lib; {
        description = "High-performance JIT compiler for Lua 5.1";
        homepage    = http://luajit.org;
        license     = licenses.mit;
        platforms   = platforms.linux ++ platforms.darwin;
        maintainers = with maintainers ; [ thoughtpolice smironov vcunat ];
      };
    };
}
