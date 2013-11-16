{ pkgs, pycairo
, version ? "stable"
, ...
}:

let inherit (pkgs) stdenv fetchurl pkgconfig glib gobjectIntrospection cairo versionedDerivation lcov autoconf automake111x libtool python;
in

versionedDerivation "pygobject" version {
  "stable" = rec {
    name = "pygobject-3.0.4";
    src = fetchurl {
      url = "http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.0/${name}.tar.xz";
      sha256 = "f457b1d7f6b8bfa727593c3696d2b405da66b4a8d34cd7d3362ebda1221f0661";
    };
    configureFlags = "--disable-introspection";
  };

  # only used by mypaint-git
  "git" = {
    # REGION AUTO UPDATE: { name="pygobject"; type="git"; url="git://git.gnome.org/pygobject"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/pygobject-git-94167.tar.bz2"; sha256 = "b50f9ef3021597dd00f28ec094761e1ac1283026d141c2747079d6eda4e62fd4"; });
    name = "pygobject-git-94167";
    # END

    buildInputs = [pkgs.gnome.gnome_common lcov autoconf automake111x libtool];

    # this is what autogen.sh would run:
    preConfigure = ''
      sh gnome-autogen.sh --enable-code-coverage
    '';
  };

}
{

  buildInputs = [ python pkgconfig glib gobjectIntrospection pycairo cairo ];

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
  };
}
