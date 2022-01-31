{ lib, stdenv, fetchurl }:

with lib;

stdenv.mkDerivation rec {
  version = "1.3.5";
  pname = "libthreadar";

  src = fetchurl {
    url = "mirror://sourceforge/libthreadar/${pname}-${version}.tar.gz";
    sha256 = "sha256-T5W83Ry3e1hHrnpmSLkfJDYHrVP6YDpXTqmf0WGCjB8=";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--disable-build-html"
  ];

  postInstall = ''
    # Disable html help
    rm -r "$out"/share
  '';

  meta = {
    homepage = "http://libthreadar.sourceforge.net/";
    description = "A C++ library that provides several classes to manipulate threads";
    longDescription = ''
      Libthreadar is a C++ library providing a small set of C++ classes to manipulate
      threads in a very simple and efficient way from your C++ code.
    '';
    maintainers = with maintainers; [ izorkin ];
    license = licenses.lgpl3;
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/libthreadar.x86_64-darwin
  };
}
