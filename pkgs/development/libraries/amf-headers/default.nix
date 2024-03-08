{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "amf-headers";
  version = "1.4.33";

  src = fetchFromGitHub {
    owner = "GPUOpen-LibrariesAndSDKs";
    repo = "AMF";
    rev = "v${version}";
    sha256 = "sha256-oho1EonWxgBmsQiX3wPhs0jQjLFwLe49C7/SOEptYiw=";
  };

  installPhase = ''
    mkdir -p $out/include/AMF
    cp -r amf/public/include/* $out/include/AMF
  '';

  meta = with lib; {
    description = "Headers for The Advanced Media Framework (AMF)";
    homepage = "https://github.com/GPUOpen-LibrariesAndSDKs/AMF";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.unix;
  };
}
