{ stdenv, fetchurl }:

let

  verbs = rec {
      version = "1.1.8";
      name = "libibverbs-${version}";
      url = "http://downloads.openfabrics.org/verbs/${name}.tar.gz";
      sha256 = "13w2j5lrrqxxxvhpxbqb70x7wy0h8g329inzgfrvqv8ykrknwxkw";
  };

  drivers = {
      libmlx4 = rec { 
          version = "1.0.6";
          name = "libmlx4-${version}"; 
          url = "http://downloads.openfabrics.org/mlx4/${name}.tar.gz";
          sha256 = "f680ecbb60b01ad893490c158b4ce8028a3014bb8194c2754df508d53aa848a8";
      };
      libmthca = rec { 
          version = "1.0.6"; 
          name = "libmthca-${version}"; 
          url = "http://downloads.openfabrics.org/mthca/${name}.tar.gz";
          sha256 = "cc8ea3091135d68233d53004e82b5b510009c821820494a3624e89e0bdfc855c";
      };
  };

in stdenv.mkDerivation rec {

  inherit (verbs) name version ;

  srcs = [
    ( fetchurl { inherit (verbs) url sha256 ; } )
    ( fetchurl { inherit (drivers.libmlx4) url sha256 ; } )
    ( fetchurl { inherit (drivers.libmthca) url sha256 ; } )
  ];

  sourceRoot = name;

  # Install userspace drivers
  postInstall = ''
    for dir in ${drivers.libmlx4.name} ${drivers.libmthca.name} ; do
      cd ../$dir
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$out/include"
      export NIX_LDFLAGS="-rpath $out/lib $NIX_LDFLAGS -L$out/lib"
      ./configure $configureFlags
      make -j$NIX_BUILD_CORES
      make install
    done
  '';

  # Re-add the libibverbs path into runpath of the library
  # to enable plugins to be found by dlopen
  postFixup = ''
    RPATH=$(patchelf --print-rpath $out/lib/libibverbs.so)
    patchelf --set-rpath $RPATH:$out/lib $out/lib/libibverbs.so.1.0.0
  '';

  meta = with stdenv.lib; {
    homepage = https://www.openfabrics.org/;
    license = licenses.bsd2;
    platforms = with platforms; linux ++ freebsd;
    maintainers = with maintainers; [ wkennington bzizou ];
  };
}

