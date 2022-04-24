{ lib, stdenv, fetchFromGitHub, cmake, ninja
, secureBuild ? false
, overrideMalloc ? true
}:

let
  soext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname   = "mimalloc";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner  = "microsoft";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-kYhfufffM4r+ZVgcjnulqFlf1756pirlPysGZnUBzt8=";
  };

  doCheck = !stdenv.hostPlatform.isStatic;
  preCheck = let
    ldLibraryPathEnv = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
  in ''
    export ${ldLibraryPathEnv}="$(pwd)/build:''${${ldLibraryPathEnv}}"
  '';

  nativeBuildInputs = [ cmake ninja ];

  cmakeFlags = [
    (lib.cmakeBool "MI_INSTALL_TOPLEVEL" true)
    (lib.cmakeBool "MI_OVERRIDE" overrideMalloc)
    (lib.cmakeBool "MI_SECURE" secureBuild)
    (lib.cmakeBool "MI_BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "MI_BUILD_TESTS" (!stdenv.hostPlatform.isStatic))
  ];

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
    ${lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    ln -sfv $out/lib/libmimalloc-secure${suffix} $out/lib/libmimalloc${suffix}
    ln -sfv $out/lib/libmimalloc-secure${suffix} $out/lib/libmimalloc${soext}
    ''}
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
