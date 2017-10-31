{ stdenv, fetchurl
, staticSupport ? false # Compile statically (support for packages that look for the static object)
}:

let
  inherit (stdenv) isDarwin;
  inherit (stdenv.lib) optional optionalString;
in

stdenv.mkDerivation rec {
  name = "gsm-${version}";
  version = "1.0.14";

  src = fetchurl {
    url = "http://www.quut.com/gsm/${name}.tar.gz";
    sha256 = "0b1mx69jq88wva3wk0hi6fcl5a52qhnq2f9p3f3jdh5k61ma252q";
  };

  patchPhase = ''
    # Fix include directory
    sed -e 's,$(GSM_INSTALL_ROOT)/inc,$(GSM_INSTALL_ROOT)/include/gsm,' -i Makefile
  '' + optionalString (!staticSupport) (
    (if isDarwin then  ''
      # Build dylib on Darwin
      sed -e 's,libgsm.a,libgsm.dylib,' -i Makefile
      sed -e 's,$(AR) $(ARFLAGS) $(LIBGSM) $(GSM_OBJECTS),$(LD) -o $(LIBGSM) -dynamiclib -install_name $(GSM_INSTALL_ROOT)/$(LIBGSM) $(GSM_OBJECTS) -lc,' -i Makefile
    '' else ''
      # Build ELF shared object by default
      sed -e 's,libgsm.a,libgsm.so,' -i Makefile
      sed -e 's/$(AR) $(ARFLAGS) $(LIBGSM) $(GSM_OBJECTS)/$(LD) -shared -Wl,-soname,libgsm.so -o $(LIBGSM) $(GSM_OBJECTS) -lc/' -i Makefile
    '') + ''
      # Remove line that is unused when building shared libraries
      sed -e 's,$(RANLIB) $(LIBGSM),,' -i Makefile
    ''
  );

  makeFlags = [
    "SHELL=${stdenv.shell}"
    "INSTALL_ROOT=$(out)"
  ] ++ optional stdenv.cc.isClang "CC=clang";

  preInstall = "mkdir -p $out/{bin,lib,man/man1,man/man3,include/gsm}";

  parallelBuild = false;

  meta = with stdenv.lib; {
    description = "Lossy speech compression codec";
    homepage    = http://www.quut.com/gsm/;
    license     = licenses.bsd2;
    maintainers = with maintainers; [ codyopel raskin ];
    platforms   = platforms.unix;
  };
}
