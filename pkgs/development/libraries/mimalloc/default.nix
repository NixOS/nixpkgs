{ stdenv, fetchFromGitHub, cmake, ninja
, secureBuild ? false
}:

let
  soext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname   = "mimalloc";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner  = "microsoft";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1zql498587wvb0gaavnzxj2zm535sgm22x0sjgl4ncfk7ragnv9c";
  };

  nativeBuildInputs = [ cmake ninja ];
  enableParallelBuilding = true;
  cmakeFlags = stdenv.lib.optional secureBuild [ "-DMI_SECURE=ON" ];

  postInstall = let
    rel = stdenv.lib.versions.majorMinor version;
  in ''
    # first, install headers, that's easy
    mkdir -p $dev
    mv $out/lib/*/include $dev/include

    # move .a and .o files into place
    find $out/lib
    mv $out/lib/mimalloc-${rel}/libmimalloc*.a           $out/lib/libmimalloc.a
    mv $out/lib/mimalloc-${rel}/mimalloc*.o              $out/lib/mimalloc.o

  '' + (if secureBuild then ''
    mv $out/lib/mimalloc-${rel}/libmimalloc-secure${soext}.${rel} $out/lib/libmimalloc-secure${soext}.${rel}
    ln -sfv $out/lib/libmimalloc-secure${soext}.${rel} $out/lib/libmimalloc-secure${soext}
    ln -sfv $out/lib/libmimalloc-secure${soext}.${rel} $out/lib/libmimalloc${soext}
  '' else ''
    mv $out/lib/mimalloc-${rel}/libmimalloc${soext}.${rel} $out/lib/libmimalloc${soext}.${rel}
    ln -sfv $out/lib/libmimalloc${soext}.${rel} $out/lib/libmimalloc${soext}
  '') + ''
    # remote duplicate dir. FIXME: try to fix the .cmake file distribution
    # so we can re-use it for dependencies...
    rm -rf $out/lib/mimalloc-${rel}
  '';

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "Compact, fast, general-purpose memory allocator";
    homepage    = "https://github.com/microsoft/mimalloc";
    license     = licenses.bsd2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
    badPlatforms = platforms.darwin;
  };
}
