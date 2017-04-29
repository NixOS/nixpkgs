{ stdenv, fetchurl, pkgconfig, libsndfile, ApplicationServices, Carbon, CoreServices }:

let
  inherit (stdenv.lib) optionals optionalString;

in stdenv.mkDerivation rec {
  name = "libsamplerate-0.1.9";

  src = fetchurl {
    url = "http://www.mega-nerd.com/SRC/${name}.tar.gz";
    sha256 = "1ha46i0nbibq0pl0pjwcqiyny4hj8lp1bnl4dpxm64zjw9lb2zha";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsndfile ]
    ++ optionals stdenv.isDarwin [ ApplicationServices CoreServices ];

  configureFlags = [ "--disable-fftw" ];

  outputs = [ "bin" "dev" "out" ];

  postConfigure = optionalString stdenv.isDarwin ''
    # need headers from the Carbon.framework in /System/Library/Frameworks to
    # compile this on darwin -- not sure how to handle
    NIX_CFLAGS_COMPILE+=" -I${Carbon}/Library/Frameworks/Carbon.framework/Headers"

    substituteInPlace examples/Makefile --replace "-fpascal-strings" ""
  '';

  meta = with stdenv.lib; {
    description = "Sample Rate Converter for audio";
    homepage    = http://www.mega-nerd.com/SRC/index.html;
    # you can choose one of the following licenses:
    # GPL or a commercial-use license (available at
    # http://www.mega-nerd.com/SRC/libsamplerate-cul.pdf)
    license     = with licenses; [ gpl3.shortName unfree ];
    maintainers = with maintainers; [ lovek323 wkennington ];
    platforms   = platforms.all;
  };
}
