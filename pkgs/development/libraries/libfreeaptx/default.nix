{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libfreeaptx";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "iamthehorker";
    repo = pname;
    rev = version;
    sha256 = "sha256-eEUhOrKqb2hHWanY+knpY9FBEnjkkFTB+x6BZgMBpbo=";
  };

  outputs = [ "out" "dev" ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile \
      --replace '-soname' '-install_name' \
      --replace 'lib$(NAME).so' 'lib$(NAME).dylib'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    # disable static builds
    "ANAME="
    "AOBJECTS="
    "STATIC_UTILITIES="
  ];

  enableParallelBuilding = true;

  postInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libfreeaptx.dylib.0 $out/lib/libfreeaptx.dylib.0 $out/bin/freeaptxdec
    install_name_tool -change libfreeaptx.dylib.0 $out/lib/libfreeaptx.dylib.0 $out/bin/freeaptxenc
    install_name_tool -id $out/lib/libfreeaptx.dylib $out/lib/libfreeaptx.dylib
    install_name_tool -id $out/lib/libfreeaptx.dylib.0 $out/lib/libfreeaptx.dylib.0
  '';

  meta = with lib; {
    description = "Free Implementation of Audio Processing Technology codec (aptX)";
    license = licenses.lgpl21Plus;
    homepage = "https://github.com/iamthehorker/libfreeaptx";
    platforms = platforms.unix;
    maintainers = with maintainers; [ kranzes ];
  };
}
