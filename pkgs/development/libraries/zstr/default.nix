{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zstr";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "mateidavid";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2GykW2IH8o7v2xAa2IIPuTEMS6WK6Edg+sw4xC/fV/U=";
  };

  installPhase = ''
    mkdir -p $out/lib/zstr/
    cp CMakeLists.txt $out/lib/zstr/zstrConfig.cmake
    cp -r src $out/include
  '';

  meta = with lib; {
    description = "A C++ header-only ZLib wrapper";
    homepage = "https://github.com/mateidavid/zstr";
    license = licenses.mit;
    maintainers = with maintainers; [ marius851000 ];
  };
}
