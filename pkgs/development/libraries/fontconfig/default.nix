{ stdenv
, fetchpatch
, substituteAll
, fetchurl
, pkg-config
, freetype
, expat
, libxslt
, gperf
, dejavu_fonts
, autoreconfHook
}:

/** Font configuration scheme
 - ./config-compat.patch makes fontconfig try the following root configs, in order:
    $FONTCONFIG_FILE, /etc/fonts/${configVersion}/fonts.conf, ${fontconfig.out}/etc/fonts/fonts.conf
    This is done not to override config of pre-2.11 versions (which just blow up)
    and still use *global* font configuration at NixOS,
    falling back to upstream defaults on non-NixOS.
 - NixOS creates /etc/fonts/${configVersion}/fonts.conf link to $out/etc/fonts/fonts.conf,
    and other modifications should go to /etc/fonts/${configVersion}/conf.d
 - See ./make-fonts-conf.xsl for config details.

*/

let
  configVersion = "2.11"; # bump whenever fontconfig breaks compatibility with older configurations
in
stdenv.mkDerivation rec {
  pname = "fontconfig";
  version = "2.13.92";

  src = fetchurl {
    url = "http://fontconfig.org/release/${pname}-${version}.tar.xz";
    sha256 = "0kkfsvxcvcphm9zcgsh646gix3qn4spz555wa1jp5hbq70l62vjh";
  };

  patches = [
    (substituteAll {
      src = ./config-compat.patch;
      inherit configVersion;
    })

    # Fix fonts not being loaded when missing included configs that have ignore_missing="yes".
    # https://bugzilla.redhat.com/show_bug.cgi?id=1744377
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/fontconfig/fontconfig/commit/fcada522913e5e07efa6367eff87ace9f06d24c8.patch";
      sha256 = "1jbm3vw45b3qjnqrh2545v1k8vmb29c09v2wj07jnrq3lnchbvmn";
    })

    # Register JoyPixels as an emoji font.
    # https://gitlab.freedesktop.org/fontconfig/fontconfig/merge_requests/67
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/fontconfig/fontconfig/commit/65087ac7ce4cc5f2109967c1380b474955dcb590.patch";
      sha256 = "1dkrbqx1c1d8yfnx0igvv516wanw2ksrpm3fbpm2h9nw0hccwqvm";
    })

    # Fix invalid DTD in reset-dirs.
    # https://gitlab.freedesktop.org/fontconfig/fontconfig/merge_requests/78
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/fontconfig/fontconfig/commit/a4aa66a858f1ecd375c5efe5916398281f73f794.patch";
      sha256 = "1j4ky8jhpllfm1lh2if34xglh2hl79nsa0xxgzxpj9sx6h4v99j5";
    })

    # Do not include its tags, they are external now and only cause warnings with old fontconfig clients.
    # https://gitlab.freedesktop.org/fontconfig/fontconfig/merge_requests/97
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/fontconfig/fontconfig/commit/528b17b2837c3b102acd90cc7548d07bacaccb1f.patch";
      sha256 = "1zf4wcd2xlprh805jalfy8ja5c2qzgkh4fwd1m9d638nl9gx932m";
    })
    # https://gitlab.freedesktop.org/fontconfig/fontconfig/merge_requests/100
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/fontconfig/fontconfig/commit/37c7c748740bf6f2468d59e67951902710240b34.patch";
      sha256 = "1rz5zrfwhpn9g49wrzzrmdglj78pbvpnw8ksgsw6bxq8l5d84jfr";
    })
  ];

  outputs = [ "bin" "dev" "lib" "out" ]; # $out contains all the config

  nativeBuildInputs = [
    gperf
    libxslt
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    expat
  ];

  propagatedBuildInputs = [
    freetype
  ];

  configureFlags = [
    "--with-arch=${stdenv.hostPlatform.parsed.cpu.name}"
    "--with-cache-dir=/var/cache/fontconfig" # otherwise the fallback is in $out/
    "--disable-docs"
    # just <1MB; this is what you get when loading config fails for some reason
    "--with-default-fonts=${dejavu_fonts.minimal}"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--with-arch=${stdenv.hostPlatform.parsed.cpu.name}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  # Don't try to write to /var/cache/fontconfig at install time.
  installFlags = [ "fc_cachedir=$(TMPDIR)/dummy" "RUN_FC_CACHE_TEST=false" ];

  postInstall = ''
    cd "$out/etc/fonts"
    xsltproc --stringparam fontDirectories "${dejavu_fonts.minimal}" \
      --stringparam fontconfig "$out" \
      --stringparam fontconfigConfigVersion "${configVersion}" \
      --path $out/share/xml/fontconfig \
      ${./make-fonts-conf.xsl} $out/etc/fonts/fonts.conf \
      > fonts.conf.tmp
    mv fonts.conf.tmp $out/etc/fonts/fonts.conf

    # Make it easier to remove user config in NixOS module.
    mkdir -p $out/etc/fonts/conf.d.bak
    mv $out/etc/fonts/conf.d/50-user.conf $out/etc/fonts/conf.d.bak

    # update latest 51-local.conf path to look at the latest local.conf
    substituteInPlace $out/etc/fonts/conf.d/51-local.conf \
      --replace local.conf /etc/fonts/${configVersion}/local.conf
  '';

  passthru = {
    inherit configVersion;
  };

  meta = with stdenv.lib; {
    description = "A library for font customization and configuration";
    homepage = "http://fontconfig.org/";
    license = licenses.bsd2; # custom but very bsd-like
    platforms = platforms.all;
    maintainers = [ maintainers.vcunat ];
  };
}
