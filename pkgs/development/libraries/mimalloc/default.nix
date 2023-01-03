{ lib, stdenv, fetchFromGitHub, cmake, ninja
, secureBuild ? false
}:

let
  soext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname   = "mimalloc";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner  = "microsoft";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-0gX0rEOWT6Lp5AyRyrK5GPTBvAqc5SxSaNJOc5GIgKc=";
  };

  doCheck = true;
  preCheck = let
    ldLibraryPathEnv = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
  in ''
    export ${ldLibraryPathEnv}="$(pwd)/build:''${${ldLibraryPathEnv}}"
  '';

  nativeBuildInputs = [ cmake ninja ];
  cmakeFlags = [ "-DMI_INSTALL_TOPLEVEL=ON" ] ++ lib.optionals secureBuild [ "-DMI_SECURE=ON" ];

  postInstall = let
    rel = lib.versions.majorMinor version;
    suffix = if stdenv.isLinux then "${soext}.${rel}" else ".${rel}${soext}";
  in ''
    # first, move headers and cmake files, that's easy
    mkdir -p $dev/lib
    mv $out/lib/cmake $dev/lib/

    find $dev $out -type f
  '' + (lib.optionalString secureBuild ''
    # pretend we're normal mimalloc
    ln -sfv $out/lib/libmimalloc-secure${suffix} $out/lib/libmimalloc${suffix}
    ln -sfv $out/lib/libmimalloc-secure${suffix} $out/lib/libmimalloc${soext}
    ln -sfv $out/lib/libmimalloc-secure.a $out/lib/libmimalloc.a
    ln -sfv $out/lib/mimalloc-secure.o $out/lib/mimalloc.o
  '');

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Compact, fast, general-purpose memory allocator";
    homepage    = "https://github.com/microsoft/mimalloc";
    license     = licenses.bsd2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ kamadorueda thoughtpolice ];
  };
}
