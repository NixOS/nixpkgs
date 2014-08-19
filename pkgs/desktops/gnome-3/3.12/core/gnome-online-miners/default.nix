{ stdenv, fetchurl, pkgconfig, glib, gnome3, libxml2
, libsoup, json_glib, gmp, openssl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "gnome-online-miners-3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-miners/3.12/${name}.tar.xz";
    sha256 = "734db67bb158a046bc8bbbe418f0fdaf6d8652ac86406907a8d17d069fa48f23";
  };

  doCheck = true;

  buildInputs = [ pkgconfig glib gnome3.libgdata libxml2 libsoup gmp openssl
                  gnome3.grilo gnome3.libzapojit gnome3.grilo-plugins
                  gnome3.gnome_online_accounts makeWrapper gnome3.libmediaart
                  gnome3.tracker gnome3.gfbgraph json_glib gnome3.rest ];

  enableParallelBuilding = true;

  preFixup = ''
    for f in $out/libexec/*; do
      wrapProgram "$f" \
        --prefix GRL_PLUGIN_PATH : "${gnome3.grilo-plugins}/lib/grilo-0.2"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeOnlineMiners;
    description = "A set of crawlers that go through your online content and index them locally in Tracker";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
