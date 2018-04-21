{ stdenv, substituteAll, fetchurl, fetchpatch
, pkgconfig, freetype, expat, libxslt, gperf, dejavu_fonts
, hostPlatform
}:

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
  name = "fontconfig-${version}";
  version = "2.12.6";

  src = fetchurl {
    url = "http://fontconfig.org/release/${name}.tar.bz2";
    sha256 = "05zh65zni11kgnhg726gjbrd55swspdvhqbcnj5a5xh8gn03036g";
  };

  patches = [
    (substituteAll {
      src = ./config-compat.patch;
      inherit configVersion;
    })
  ];

  outputs = [ "bin" "dev" "lib" "out" ]; # $out contains all the config

  propagatedBuildInputs = [ freetype ];
  nativeBuildInputs = [ pkgconfig gperf ];
  buildInputs = [ expat ];

  configureFlags = [
    "--with-cache-dir=/var/cache/fontconfig" # otherwise the fallback is in $out/
    "--disable-docs"
    # just <1MB; this is what you get when loading config fails for some reason
    "--with-default-fonts=${dejavu_fonts.minimal}"
  ];

  # We should find a better way to access the arch reliably.
  crossArch = hostPlatform.arch or null;

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

