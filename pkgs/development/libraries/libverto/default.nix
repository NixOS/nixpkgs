{ stdenv, fetchurl, pkgconfig

# Optional Dependencies
, glib ? null, libev ? null, libevent ? null, tevent ? null, talloc ? null
}:
with stdenv;
let
  optGlib = shouldUsePkg glib;
  optLibev = shouldUsePkg libev;
  optLibevent = shouldUsePkg libevent;
  optTevent = shouldUsePkg tevent;
  optTalloc = shouldUsePkg talloc;
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libverto-0.2.6";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/libverto/${name}.tar.gz";
    sha256 = "17hwr55ga0rkm5cnyfiipyrk9n372x892ph9wzi88j2zhnisdv0p";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ optGlib optLibev optLibevent ]
    ++ optionals (optTevent != null && optTalloc != null) [
      optTevent optTalloc
    ];

  postInstall = ''
    # In v0.2.6 the shipped pkg-config files have an out of order
    # declaration of exec_prefix breaking them. This fixes that issue
    sed -i 's,''${exec_prefix},''${prefix},g' $out/lib/pkgconfig/*.pc
  '';

  meta = {
    homepage = https://fedorahosted.org/libverto/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
