{ stdenv, fetchurl, fetchpatch, pkgconfig, which, zlib, bzip2, libpng, gnumake
  # FreeType supports sub-pixel rendering.  This is patented by
  # Microsoft, so it is disabled by default.  This option allows it to
  # be enabled.  See http://www.freetype.org/patents.html.
, glib/*passthru only*/
, useEncumberedCode ? true
}:

let
  version = "2.5.4";

  fetch_bohoomil = name: sha256: fetchpatch {
    url = https://raw.githubusercontent.com/bohoomil/fontconfig-ultimate/e4c99bcf5ac9595e2c64393c0661377685c0ad24/01_freetype2-iu/ + name;
    inherit sha256;
  };
in
with { inherit (stdenv.lib) optional optionals optionalString; };
stdenv.mkDerivation rec {
  name = "freetype-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/freetype/${name}.tar.bz2";
    sha256 = "1fxsbk4lp6ymifldzrb86g3x6mz771jmrzphkz92mcrkddk2qkiv";
  };

  patches = [ ./enable-validation.patch ] # from Gentoo, bohoomil has the same patch as well
    ++ optionals useEncumberedCode [
      (fetch_bohoomil "02-ftsmooth-2.5.4.patch" "11w4wb7gwgpijc788mpkxj92d7rfdwrdv7jzrpxwv5w5cgpx9iw9")
      (fetch_bohoomil "03-upstream-2014.12.07.patch" "0gq7y63mg3gc5z69nfkv2kl7xad0bjzsvnl6j1j9q79jjbvaqdq0")
      (fetch_bohoomil "04-infinality-2.5.4-2014.12.07.patch" "1gph7z9s2221gy5dxn01v3lga0m9yib8yqsaqj5km74bqx1vlalh")
    ];

  propagatedBuildInputs = [ zlib bzip2 libpng ]; # needed when linking against freetype
  # dependence on harfbuzz is looser than the reverse dependence
  buildInputs = [ pkgconfig which ]
    # FreeType requires GNU Make, which is not part of stdenv on FreeBSD.
    ++ optional (!stdenv.isLinux) gnumake;

  # from Gentoo, see https://bugzilla.redhat.com/show_bug.cgi?id=506840
  NIX_CFLAGS_COMPILE = "-fno-strict-aliasing";
  # The asm for armel is written with the 'asm' keyword.
  CFLAGS = optionalString stdenv.isArm "-std=gnu99";

  enableParallelBuilding = true;

  doCheck = true;

  # compat hacks
  postInstall = glib.flattenInclude + ''
    ln -s . "$out"/include/freetype
  '';

  crossAttrs = {
    # Somehow it calls the unwrapped gcc, "i686-pc-linux-gnu-gcc", instead
    # of gcc. I think it's due to the unwrapped gcc being in the PATH. I don't
    # know why it's on the PATH.
    configureFlags = "--disable-static CC_BUILD=gcc";
  };

  meta = with stdenv.lib; {
    description = "A font rendering engine";
    homepage = http://www.freetype.org/;
    license = licenses.gpl2Plus; # or the FreeType License (BSD + advertising clause)
    #ToDo: encumbered = useEncumberedCode;
    platforms = platforms.all;
  };
}
