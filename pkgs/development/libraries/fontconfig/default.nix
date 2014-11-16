{ stdenv, fetchurl, fetchpatch, pkgconfig, freetype, expat, libxslt, fontbhttf
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
  name = "fontconfig-2.11.1";

  src = fetchurl {
    url = "http://fontconfig.org/release/${name}.tar.bz2";
    sha256 = "16baa4g5lswkyjlyf1h5lwc0zjap7c4d8grw79349a5w6dsl8qnw";
  };

  infinality_patch =
    let subvers = "1";
      in fetchurl {
        url = http://www.infinality.net/fedora/linux/zips/fontconfig-infinality-1-20130104_1.tar.bz2;
        sha256 = "1fm5xx0mx2243jrq5rxk4v0ajw2nawpj23399h710bx6hd1rviq7";
      }
    ;

  patches = [
    (fetchpatch {
      url = "http://cgit.freedesktop.org/fontconfig/patch/?id=f44157c809d280e2a0ce87fb078fc4b278d24a67";
      sha256 = "19s5irclg4irj2yxd7xw9yikbazs9263px8qbv4r21asw06nfalv";
    })
    (substituteAll {
      src = ./config-compat.patch;
      inherit configVersion;
    })
  ];

  propagatedBuildInputs = [ freetype ];
  buildInputs = [ pkgconfig expat ];

  configureFlags = [
    "--with-cache-dir=/var/cache/fontconfig" # otherwise the fallback is in $out/
    "--disable-docs"
    # just ~1MB; this is what you get when loading config fails for some reason
    "--with-default-fonts=${fontbhttf}"
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
    cd "$out/etc/fonts" && tar xvf ${infinality_patch}
    rm conf.d/{50-user,51-local}.conf
    "${libxslt}/bin/xsltproc" --stringparam fontDirectories "${fontbhttf}" \
      --stringparam fontconfig "$out" \
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

