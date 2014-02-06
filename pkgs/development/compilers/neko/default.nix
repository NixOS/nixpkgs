{ stdenv, fetchurl, boehmgc, zlib, sqlite, pcre, versionedDerivation
, apache, apr, aprutil
, version ? "2.0.0"
}:

let
  m = list: stdenv.lib.concatStringsSep "," (map (x: "$hash(\"${x}\")") list);

  # yes - this should be built "on its own" (to be improved)
  apacheModules = stdenv.lib.optionals (apache != null) ["mod_tora2" "mod_neko2"];
in

versionedDerivation  "neko" version {

  "git" = rec {
    # REGION AUTO UPDATE: { name="neko"; type="git"; url="https://github.com/HaxeFoundation/neko.git"; groups = "haxe_group"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/neko-git-0c5d3.tar.bz2"; sha256 = "aac7aee410f7edeb840777c9c73bacda07c7d4f262f455e3af0444b295c73605"; });
    name = "neko-git-0c5d3";
    # END

    modules_to_build = m (["mysql5" "regexp" "zlib" "sqlite"] ++ apacheModules);
  };

  "2.0.0" = rec {
    version = "2.0.0";
    # mod_neko, mod_tora for apache 1.34
    # mod_neko2, mod_tora2 for apache 2.2x

    src = fetchurl {
      url = "http://nekovm.org/_media/neko-2.0.0.tar.gz";
      sha256 = "1lcm1ahbklfpd5lnqjwmvyj2vr85jbq57hszk5jgq0x6yx6p3927";
    };
    # available: mod_neko mod_neko2 mysql mysql5 regexp zlib sqlite ui mod_tora mod_tora2
    # to be tested (important): "mysql5" "mod_tora" "sqlite"
    modules_to_build = m (["mysql5" "regexp" "zlib" "sqlite"] ++ apacheModules);
  };

} (rec {

  name = "neko-${version}";

  enableParalellBuilding = true;

  NIX_CFLAGS_COMPILE="-I${apr}/include/apr-1 -I${aprutil}/include/apr-1";

  prePatch = with stdenv.lib; let
    libs = concatStringsSep "," (map (lib: "\"${lib}/include\"") buildInputs);
  in
    # [1] make loop_include return dummy path -I gets added by NIX_CFLAGS_COMPILE anyway
    # In the nixos and httpd.h / apr.h case there might be multiple directories
    # to be returned which install.neko doesn't support
    ''
    sed -i -e '/^search_includes/,/^}/c \
      search_includes = function(_) { return $array(${libs}) }
    ' src/tools/install.neko
    sed -i -e '/allocated = strdup/s|"[^"]*"|"'"$out/lib/neko:$out/bin"'"|' \
      vm/load.c
    # temporarily, fixed in 1.8.3
    sed -i -e 's/^#if defined(_64BITS)/& || defined(__x86_64__)/' vm/neko.h

    # only build the libs we want [1]
    sed -i \
        -e "s@var liblist = \$objfields(libs);@var liblist = \$array(''${modules_to_build});@" \
        -e "s@\\(loop_include = function(data,i,incl) {\\)@\1 return \"does-not-exist\";@" \
        src/tools/install.neko
  '';

  makeFlags = "INSTALL_PREFIX=$(out)";
  buildInputs = [ boehmgc zlib sqlite pcre apache apr aprutil];
  dontStrip = true;

  preInstall = ''
    install -vd "$out/lib" "$out/bin"
  '';

  meta = {
    description = "A high-level dynamically typed programming language";
    homepage = http://nekovm.org;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
})
