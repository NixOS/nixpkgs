{ stdenv, fetchurl, androidndk, ndkWrapper, ncurses }: 

stdenv.mkDerivation rec {
  iname = "ncurses";
  suffix = "androidndk";
  version = "5.9";
  name = iname + "-" + suffix + "-" + version;

  src = fetchurl {
    url = "mirror://gnu/ncurses/${iname}-${version}.tar.gz";
    sha256 = "0fsn7xis81za62afan0vvm38bvgzg5wfmv1m86flqcj0nj7jjilh";
  };

  configureFlags = [ "--host=arm"
                     "--enable-static"
                     "--disable-shared"
                     "--without-manpages"
                     "--without-debug"
		     "--without-termlib"
		     "--without-ticlib"
		     "--without-cxx" ];

  buildInputs = [ ncurses ];
  phases = [ "unpackPhase" "configurePhase" "buildPhase" "installPhase" ];  

  preConfigure = ''
    configureFlagsArray+=("--includedir=$out/include")
    export NDK=${androidndk}/libexec/${androidndk.name}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
    export NDK_TARGET=arm-linux-androideabi
    export CC=${ndkWrapper}/bin/$NDK_TARGET-gcc
    export CPP=${ndkWrapper}/bin/$NDK_TARGET-cpp
    export CXX=${ndkWrapper}/bin/$NDK_TARGET-g++
    export LD=${ndkWrapper}/bin/$NDK_TARGET-ld
    export RANLIB=${ndkWrapper}/bin/$NDK_TARGET-gcc-ranlib
    export NM=${ndkWrapper}/bin/$NDK_TARGET-gcc-nm
    export PKG_CONFIG_LIBDIR="$out/lib/pkgconfig"
    mkdir -p "$PKG_CONFIG_LIBDIR"
  '';

  selfNativeBuildInput = true;

  enableParallelBuilding = true;

  doCheck = false;

}
