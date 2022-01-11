{ lib, stdenv, fetchFromGitHub, cmake, ninja
, secureBuild ? false
}:

let
  soext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname   = "mimalloc";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner  = "microsoft";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-n4FGld3bq6ZOSLTzXcVlucCGbQ5/eSFbijU0dfBD/T0=";
  };

  nativeBuildInputs = [ cmake ninja ];
  cmakeFlags = [ "-DMI_INSTALL_TOPLEVEL=ON" ] ++ lib.optional secureBuild [ "-DMI_SECURE=ON" ];

  postInstall = let
    rel = lib.versions.majorMinor version;
    suffix = if stdenv.isLinux then "${soext}.${rel}" else ".${rel}${soext}";
  in ''
    # first, move headers and cmake files, that's easy
    mkdir -p $dev/lib
    mv $out/include $dev/include
    mv $out/cmake $dev/lib/

    find $out/lib
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
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
