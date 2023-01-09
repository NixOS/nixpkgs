{ stdenv, lib, fetchFromGitHub, cmake, boost, pkg-config, lcms2, tinyxml, git }:

stdenv.mkDerivation rec {
  pname = "opencolorio";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "imageworks";
    repo = "OpenColorIO";
    rev = "v${version}";
    sha256 = "12srvxca51czpfjl0gabpidj9n84mw78ivxy5w75qhq2mmc798sb";
  };

  outputs = [ "bin" "out" "dev" ];

  # TODO: Investigate whether git can be dropped: It's only used to apply patches
  nativeBuildInputs = [ cmake pkg-config git ];

  buildInputs = [ lcms2 tinyxml ] ++ lib.optional stdenv.isDarwin boost;

  postPatch = ''
    substituteInPlace src/core/CMakeLists.txt --replace "-Werror" ""
    substituteInPlace src/pyglue/CMakeLists.txt --replace "-Werror" ""
  '';

  cmakeFlags = [
    "-DUSE_EXTERNAL_LCMS=ON"
    "-DUSE_EXTERNAL_TINYXML=ON"
    # External libyamlcpp 0.6.* not compatible: https://github.com/imageworks/OpenColorIO/issues/517
    "-DUSE_EXTERNAL_YAML=OFF"
  ] ++ lib.optional stdenv.isDarwin "-DOCIO_USE_BOOST_PTR=ON"
    ++ lib.optional (!stdenv.hostPlatform.isx86) "-DOCIO_USE_SSE=OFF"
    ++ lib.optional (stdenv.isDarwin && stdenv.isAarch64) "-DCMAKE_OSX_ARCHITECTURES=arm64";

  postInstall = ''
    moveToOutput bin "$bin"
    moveToOutput cmake "$dev"
    moveToOutput OpenColorIOConfig.cmake "$dev"

    substituteInPlace "$dev/cmake/OpenColorIO-release.cmake" \
      --replace "$out/bin" "$bin/bin"
  '';

  meta = with lib; {
    homepage = "https://opencolorio.org";
    description = "A color management framework for visual effects and animation";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
