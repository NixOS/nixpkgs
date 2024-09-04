{ lib, stdenv, fetchurl, pkg-config, libsndfile, ApplicationServices, Carbon, CoreServices }:

let
  inherit (lib) optionals optionalString;

in stdenv.mkDerivation rec {
  pname = "libsamplerate";
  version = "0.2.2";

  src = fetchurl {
    url = "https://github.com/libsndfile/libsamplerate/releases/download/${version}/libsamplerate-${version}.tar.xz";
    hash = "sha256-MljaKAUR0ktJ1rCGFbvoJNDKzJhCsOTK8RxSzysEOJM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsndfile ]
    ++ optionals stdenv.isDarwin [ ApplicationServices CoreServices ];

  configureFlags = [ "--disable-fftw" ];

  outputs = [ "dev" "out" ];

  postConfigure = optionalString stdenv.isDarwin ''
    # need headers from the Carbon.framework in /System/Library/Frameworks to
    # compile this on darwin -- not sure how to handle
    NIX_CFLAGS_COMPILE+=" -I${Carbon}/Library/Frameworks/Carbon.framework/Headers"
  '';

  meta = with lib; {
    description = "Sample Rate Converter for audio";
    homepage    = "https://libsndfile.github.io/libsamplerate/";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.all;
    # Linker is unhappy with the `.def` file.
    broken      = stdenv.hostPlatform.isMinGW;
  };
}
