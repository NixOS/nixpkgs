{
  lib,
  stdenv,
  fetchurl,
  cmake,
  gfortran,
  # Whether to build with ILP64 interface
  blas64 ? false,
}:

stdenv.mkDerivation rec {
  pname = "blas";
  version = "3.12.0";

  src = fetchurl {
    url = "http://www.netlib.org/blas/${pname}-${version}.tgz";
    sha256 = "sha256-zMQbXQiOUNsAMDF66bDJrzdXEME5KsrR/iCWAtpaWq0=";
  };

  passthru = {
    inherit blas64;
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ] ++ lib.optional blas64 "-DBUILD_INDEX64=ON";

  postInstall =
    let
      canonicalExtension =
        if stdenv.hostPlatform.isLinux then
          "${stdenv.hostPlatform.extensions.sharedLibrary}.${lib.versions.major version}"
        else
          stdenv.hostPlatform.extensions.sharedLibrary;
    in
    lib.optionalString blas64 ''
      ln -s $out/lib/libblas64${canonicalExtension} $out/lib/libblas${canonicalExtension}
    '';

  preFixup = lib.optionalString stdenv.isDarwin ''
    for fn in $(find $out/lib -name "*.so*"); do
      if [ -L "$fn" ]; then continue; fi
      install_name_tool -id "$fn" "$fn"
    done
  '';

  meta = with lib; {
    description = "Basic Linear Algebra Subprograms";
    license = licenses.publicDomain;
    maintainers = [ maintainers.markuskowa ];
    homepage = "http://www.netlib.org/blas/";
    platforms = platforms.unix;
  };
}
