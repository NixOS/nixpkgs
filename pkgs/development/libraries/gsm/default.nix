{ stdenv, fetchurl }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "gsm-${version}";
  version = "1.0.13";

  src = fetchurl {
    url = "http://www.quut.com/gsm/${name}.tar.gz";
    sha256 = "1bcjl2h60gvr1dc5a963h3vnz9zl6n8qrfa3qmb2x3229lj1iiaj";
  };

  patchPhase = ''
    # Fix include directory
    sed -e 's,$(GSM_INSTALL_ROOT)/inc,$(GSM_INSTALL_ROOT)/include/gsm,' -i Makefile

    makeFlags="$makeFlags INSTALL_ROOT=$out"

    # Build shared library instead of static
    sed -e 's,-c -O2 -DNeedFunctionPrototypes=1,-c -O2 -fPIC -DNeedFunctionPrototypes=1,' -i Makefile
    sed -e 's,libgsm.a,libgsm.so,' -i Makefile
    sed -e 's/$(AR) $(ARFLAGS) $(LIBGSM) $(GSM_OBJECTS)/$(LD) -shared -Wl,-soname,libgsm.so -o $(LIBGSM) $(GSM_OBJECTS) -lc/' -i Makefile
    sed -e 's,$(RANLIB) $(LIBGSM),,' -i Makefile
  '';

  makeFlags = [
    ''SHELL=${stdenv.shell}''
  ];

  preInstall = ''
    mkdir -p "$out/"{bin,lib,man/man1,man/man3,include/gsm}
  '';

  NIX_CFLAGS_COMPILE = "-fPIC";

  parallelBuild = false;

  meta = {
    description = "Lossy speech compression codec";
    homepage    = http://www.quut.com/gsm/;
    license     = licenses.bsd2;
    maintainers = with maintainers; [ codyopel raskin ];
    platforms   = platforms.all;
  };
}
