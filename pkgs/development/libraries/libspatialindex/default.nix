{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspatialindex";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "libspatialindex";
    repo = "libspatialindex";
    rev = finalAttrs.version;
    hash = "sha256-hZyAXz1ddRStjZeqDf4lYkV/g0JLqLy7+GrSUh75k20=";
  };

  postPatch = ''
    patchShebangs test/
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)

    # The cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR
    # correctly (setting it to an absolute path causes include files to go to
    # $out/$out/include,  because the absolute path is interpreted with root
    # at $out).
    # See: https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
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
