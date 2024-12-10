{
  lib,
  stdenv,
  fetchurl,
  gcc-unwrapped,
}:

stdenv.mkDerivation rec {
  version = "1.4.0";
  pname = "libthreadar";

  src = fetchurl {
    url = "mirror://sourceforge/libthreadar/${pname}-${version}.tar.gz";
    sha256 = "sha256-LkcVF4AnuslzpIg/S8sGNJQye6iGcQRGqCqAhg8aN5E=";
  };

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [ gcc-unwrapped ];

  CXXFLAGS = [ "-std=c++14" ];

  configureFlags = [
    "--disable-build-html"
  ];

  postInstall = ''
    # Disable html help
    rm -r "$out"/share
  '';

  meta = with lib; {
    homepage = "https://libthreadar.sourceforge.net/";
    description = "A C++ library that provides several classes to manipulate threads";
    longDescription = ''
      Libthreadar is a C++ library providing a small set of C++ classes to manipulate
      threads in a very simple and efficient way from your C++ code.
    '';
    maintainers = with maintainers; [ izorkin ];
    license = licenses.lgpl3;
    platforms = platforms.unix;
  };
}
