args:
( args.mkDerivationByConfigruation {
    flagConfig = {
      mandatory = { buildInputs = ["pkgconfig"];};
    # are these options of interest? We'll see
    #--disable-fftw          disable usage of FFTW
    #--enable-debug          enable debugging
    #--disable-cpu-clip      disable tricky cpu specific clipper

    }; 

    extraAttrs = co : {
      name = "libsamplerate-0.1.2";

      src = args.fetchurl {
        url = http://www.mega-nerd.com/SRC/libsamplerate-0.1.2.tar.gz;
        sha256 = "1m1iwzpcny42kcqv5as2nyb0ggrb56wzckpximqpp2y74dipdf4q";
      };

    configurePhase = "
     export LIBSAMPLERATE_CFLAGS=\"-I \$libsamplerate/include\"
     export LIBSAMPLERATE_LIBS=\"-L \$libsamplerate/libs\"
     ./configure --prefix=\$out"+co.configureFlags;

    meta = { 
      description = "Sample Rate Converter for audio";
      homepage = http://www.mega-nerd.com/SRC/index.html;
      # you can choose one of the following licenses: 
      license = [ "GPL" 
                  { url=http://www.mega-nerd.com/SRC/libsamplerate-cul.pdf; 
                    name="libsamplerate Commercial Use License";
                  } ];
    };
  };
} ) args
