{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspatialindex";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "libspatialindex";
    repo = "libspatialindex";
    rev = finalAttrs.version;
    hash = "sha256-zsvS0IkCXyuNLCQpccKdAsFKoq0l+y66ifXlTHLNTkc=";
  };

  patches = [
    # Allow building static libs
    (fetchpatch {
      name = "fix-static-lib-build.patch";
      url = "https://github.com/libspatialindex/libspatialindex/commit/caee28d84685071da3ff3a4ea57ff0b6ae64fc87.patch";
      hash = "sha256-nvTW/t9tw1ZLeycJY8nj7rQgZogxQb765Ca2b9NDvRo=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DSIDX_BUILD_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Extensible spatial index library in C++";
    homepage = "https://libspatialindex.org";
    license = licenses.mit;
    maintainers = teams.geospatial.members;
    platforms = platforms.unix;
  };
})
