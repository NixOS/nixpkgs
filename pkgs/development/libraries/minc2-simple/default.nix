{ stdenv, fetchFromGitHub, cmake, libminc }:

stdenv.mkDerivation rec {
  version  = "2018-12-20";
  name     = "minc2-simple-${version}";

  src = fetchFromGitHub {
    owner  = "vfonov";
    repo   = "minc2-simple";
    rev    = "e04414eb74052d8a6f9fb4bedda7f0894e86ac82";
    sha256 = "1miy942ibbcikg0k45d7342ags2gpr29rvhvspwxqgv2jnpcwg05";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libminc ];

  cmakeFlags = [ "-DBUILD_TESTING=OFF" "-DLIBMINC_DIR=${libminc}/lib/" ];

  # no cmake 'install' target
  installPhase = ''
    mkdir -p $out/lib
    cp src/*.a src/*.so $out/lib
  '';

  # tests don't actually run automatically, e.g., missing input files
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/vfonov/minc2-simple";
    description = "Simple interface to the libminc medical imaging library";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license   = licenses.free;
  };
}
