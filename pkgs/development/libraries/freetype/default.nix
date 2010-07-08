{ stdenv, fetchurl
, # FreeType supports hinting using a TrueType bytecode interpreter,
  # as well as sub-pixel rendering.  These are patented by Apple and
  # Microsoft, respectively, so they are disabled by default.  This
  # option allows them to be enabled.  See
  # http://www.freetype.org/patents.html.
  useEncumberedCode ? false
}:

stdenv.mkDerivation (rec {
  name = "freetype-2.3.11";
  
  src = fetchurl {
    url = "mirror://sourceforge/freetype/${name}.tar.bz2";
    sha256 = "1j9f3q7vkdhlcxmfhkkyvxmniih2gcsb428v73mfk88qc0g3n0wa";
  };

  configureFlags = "--disable-static";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString useEncumberedCode
    "-DFT_CONFIG_OPTION_SUBPIXEL_RENDERING=1 -DTT_CONFIG_OPTION_BYTECODE_INTERPRETER=1";

  meta = {
    description = "A font rendering engine";
    homepage = http://www.freetype.org/;
    license = "GPLv2+"; # or the FreeType License (BSD + advertising clause)
  };
} //
# The asm for armel is written with the 'asm' keyword.
(if (stdenv.system == "armv5tel-linux") then 
    {CFLAGS = "-std=gnu99";} else {}))
