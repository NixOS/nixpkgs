{ stdenv, fetchurl, fetchpatch, pkgconfig, freetype, expat, libxslt, dejavu_fonts
, substituteAll }:

/** Font configuration scheme
 - ./config-compat.patch makes fontconfig try the following root configs, in order:
    $FONTCONFIG_FILE, /etc/fonts/${configVersion}/fonts.conf, /etc/fonts/fonts.conf
    This is done not to override config of pre-2.11 versions (which just blow up)
    and still use *global* font configuration at both NixOS or non-NixOS.
 - NixOS creates /etc/fonts/${configVersion}/fonts.conf link to $out/etc/fonts/fonts.conf,
    and other modifications should go to /etc/fonts/${configVersion}/conf.d
 - See ./make-fonts-conf.xsl for config details.

*/

let
  configVersion = "2.11"; # bump whenever fontconfig breaks compatibility with older configurations
in
stdenv.mkDerivation rec {
  name = "fontconfig-2.12.1";

  src = fetchurl {
    url = "http://fontconfig.org/release/${name}.tar.bz2";
    sha256 = "1wy7svvp7df6bjpg1m5vizb3ngd7rhb20vpclv3x3qa71khs6jdl";
  };

  patches = [
    (substituteAll {
      src = ./config-compat.patch;
      inherit configVersion;
    })
    (fetchpatch {
      name = "glibc-2.25.diff";
      url = "https://cgit.freedesktop.org/fontconfig/patch/?id=1ab5258f7c";
      sha256 = "0x2a4qx51j3gqcp1kp4lisdzmhrkw1zw0r851d82ksgjlc0vkbaz";
    })
  ];
  # additionally required for the glibc-2.25 patch; avoid requiring gperf
  postPatch = ''
    sed s/CHAR_WIDTH/CHARWIDTH/g -i src/fcobjshash.{h,gperf}
    touch src/*
  '';

  outputs = [ "bin" "dev" "lib" "out" ]; # $out contains all the config

  propagatedBuildInputs = [ freetype ];
  buildInputs = [ pkgconfig expat ];

  configureFlags = [
    "--with-cache-dir=/var/cache/fontconfig" # otherwise the fallback is in $out/
    "--disable-docs"
    # just <1MB; this is what you get when loading config fails for some reason
    "--with-default-fonts=${dejavu_fonts.minimal}"
  ];

  # We should find a better way to access the arch reliably.
  crossArch = stdenv.cross.arch or null;

  preConfigure = ''
    if test -n "$crossConfig"; then
      configureFlags="$configureFlags --with-arch=$crossArch";
    fi
  '';

  enableParallelBuilding = true;

  doCheck = true;

  # Don't try to write to /var/cache/fontconfig at install time.
  installFlags = "fc_cachedir=$(TMPDIR)/dummy RUN_FC_CACHE_TEST=false";

  postInstall = ''
    cd "$out/etc/fonts"
    "${libxslt.bin}/bin/xsltproc" --stringparam fontDirectories "${dejavu_fonts.minimal}" \
      --stringparam fontconfigConfigVersion "${configVersion}" \
      --path $out/share/xml/fontconfig \
      ${./make-fonts-conf.xsl} $out/etc/fonts/fonts.conf \
      > fonts.conf.tmp
    mv fonts.conf.tmp $out/etc/fonts/fonts.conf
  '';

  passthru = {
    inherit configVersion;
  };

  meta = with stdenv.lib; {
    description = "A library for font customization and configuration";
    homepage = http://fontconfig.org/;
    license = licenses.bsd2; # custom but very bsd-like
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}

