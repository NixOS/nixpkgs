{ stdenv, lib, fetchFromGitHub, cmake, boost, pkgconfig, lcms2, tinyxml, git }:

with lib;

stdenv.mkDerivation rec {
  name = "opencolorio-${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "imageworks";
    repo = "OpenColorIO";
    rev = "v${version}";
    sha256 = "12srvxca51czpfjl0gabpidj9n84mw78ivxy5w75qhq2mmc798sb";
  };

  outputs = [ "bin" "out" "dev" ];

  # TODO: Investigate whether git can be dropped: It's only used to apply patches
  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [ lcms2 tinyxml ] ++ optional stdenv.isDarwin boost;

  postPatch = ''
    substituteInPlace src/core/CMakeLists.txt --replace "-Werror" ""
    substituteInPlace src/pyglue/CMakeLists.txt --replace "-Werror" ""
  '';

  cmakeFlags = [
    "-DUSE_EXTERNAL_LCMS=ON"
    "-DUSE_EXTERNAL_TINYXML=ON"
    # External libyamlcpp 0.6.* not compatible: https://github.com/imageworks/OpenColorIO/issues/517
    "-DUSE_EXTERNAL_YAML=OFF"
  ] ++ optional stdenv.isDarwin "-DOCIO_USE_BOOST_PTR=ON"
    ++ optional (!stdenv.hostPlatform.isi686 && !stdenv.hostPlatform.isx86_64) "-DOCIO_USE_SSE=OFF";

  postInstall = ''
    mkdir -p $bin/bin; mv $out/bin $bin/
  '';

  meta = with stdenv.lib; {
    homepage = http://opencolorio.org;
    description = "A color management framework for visual effects and animation";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
