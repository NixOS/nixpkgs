{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "openvg-headers";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenVG-Registry";
    rev = "7a3bd5f4ae8243db01ff6ba703bc84d0ac2c1dc3";
    sha256 = "5GTrTvQshyRB0w0sEuKDJjiDnWHswudNMb4XPGBVS6E=";
  };

  buildPhase = ":";

  installPhase = ''
    mkdir -p $out/include/VG
    cp ${src}/api/1.1/* $out/include/VG
  '';

  meta = with lib; {
    description = "OpenVG Header files and API registry";
    homepage    = "https://www.khronos.org/registry/OpenVG/";
    platforms   = platforms.linux;
    license     = licenses.asl20; # assume same license as vulkan-headers
    #maintainers = [ maintainers.ralith ];
  };
}
