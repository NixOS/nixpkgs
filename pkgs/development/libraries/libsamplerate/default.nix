{ stdenv, fetchurl, pkgconfig, libsndfile, ApplicationServices, Carbon, CoreServices }:

let
  inherit (stdenv.lib) optionals optionalString;

in stdenv.mkDerivation rec {
  name = "libsamplerate-0.1.8";

  src = fetchurl {
    url = "http://www.mega-nerd.com/SRC/${name}.tar.gz";
    sha256 = "01hw5xjbjavh412y63brcslj5hi9wdgkjd3h9csx5rnm8vglpdck";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsndfile ]
    ++ optionals stdenv.isDarwin [ ApplicationServices CoreServices ];

  # maybe interesting configure flags:
  #--disable-fftw          disable usage of FFTW
  #--disable-cpu-clip      disable tricky cpu specific clipper

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
    licenses    = with licenses; [ gpl3.shortName unfree ];
    maintainers = with maintainers; [ lovek323 wkennington ];
    platforms   = platforms.all;
  };
}
