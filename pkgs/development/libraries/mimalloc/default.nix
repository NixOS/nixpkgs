{ stdenv, fetchFromGitHub, cmake, ninja
, secureBuild ? true
}:

let
  soext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname   = "mimalloc";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner  = "microsoft";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "1i8pwzpcmbf7dxncb984xrnczn1737xqhf1jaizlyw0k1hpiam4v";
  };

  nativeBuildInputs = [ cmake ninja ];
  enableParallelBuilding = true;
  cmakeFlags = stdenv.lib.optional secureBuild [ "-DMI_SECURE=ON" ];

  postInstall = ''
    # first, install headers, that's easy
    mkdir -p $dev
    mv $out/lib/*/include $dev/include

    # move everything else into place
    mv $out/lib/mimalloc-1.0/libmimalloc*${soext}.1.0 $out/lib/libmimalloc${soext}
    mv $out/lib/mimalloc-1.0/libmimalloc*.a           $out/lib/libmimalloc.a
    mv $out/lib/mimalloc-1.0/mimalloc*.o              $out/lib/mimalloc.o

    # remote duplicate dir. FIXME: try to fix the .cmake file distribution
    # so we can re-use it for dependencies...
    rm -rf $out/lib/mimalloc-1.0
  '' + stdenv.lib.optionalString secureBuild ''
    # fix a broken symlink for the -secure alias
    ln -sfv $out/lib/libmimalloc.so $out/lib/libmimalloc-secure.so
  '';

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "Compact, fast, general-purpose memory allocator";
    homepage    = "https://github.com/microsoft/mimalloc";
    license     = licenses.bsd2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
