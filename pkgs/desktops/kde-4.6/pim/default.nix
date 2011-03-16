{ kde, fetchurl, cmake, perl, boost, gpgme, libassuan, libgpgerror, libxslt
, shared_mime_info, libXScrnSaver, kdelibs, kdepimlibs, kdepim_runtime
, automoc4, akonadi, qca2, gettext, grantlee}:

kde.package rec {

  buildInputs = [ cmake boost gpgme libassuan libgpgerror libxslt
    shared_mime_info libXScrnSaver kdelibs kdepimlibs automoc4 akonadi gettext
    grantlee ];
  postInstall = ''
      mkdir -p $out/nix-support/
      echo ${akonadi} ${kdepimlibs} ${kdepim_runtime} > $out/nix-support/propagated-user-env-packages
  '';

  src = fetchurl {
    url = "mirror://kde/unstable/kdepim/${meta.kde.release}/src/${meta.kde.module}-${meta.kde.release}.tar.bz2";
    sha256 = "1bnlyrflcjy7lj4c2jag212ws2gzzpqyn5g2p97x8y936dza7ic3";
  };

  meta = {
    description = "KDE PIM tools";
    longDescription = ''
      Contains various personal information management tools for KDE, such as an organizer
    '';
    license = "GPL";
    homepage = http://pim.kde.org;
    kde = {
      release = "4.5.94.1";
      module = "kdepim";
    };
  };
}
