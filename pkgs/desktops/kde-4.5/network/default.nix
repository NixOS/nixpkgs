{ kde, cmake, qt4, perl, speex, gmp, libxml2, libxslt, sqlite, alsaLib, libidn
, libvncserver, libmsn, giflib, gpgme, boost, libv4l, libotr
, libXi, libXtst, libXdamage, libXxf86vm, libktorrent, kdebase
, kdebase_workspace
, kdelibs, kdepimlibs, automoc4, qca2, soprano, qimageblitz, strigi}:

kde.package {

  buildInputs = [ cmake qt4 perl speex gmp libxml2 libxslt sqlite alsaLib libidn
    libvncserver libmsn giflib gpgme boost libv4l libotr libXi libXtst
    libXdamage libXxf86vm kdelibs kdepimlibs automoc4 qca2 soprano
    qimageblitz strigi libktorrent kdebase kdebase_workspace ];

  patches = [ ./log-feature.diff ];
#TODO
# * telepathy-qt4 (0.18 or higher)  <http://telepathy.freedesktop.org>
# * KWebKitPart  <https://svn.kde.org/home/kde/trunk/extragear/base/kwebkitpart>
# * libortp (0.13 or higher)  <http://www.linphone.org/index.php/eng/code_review/ortp>
# * XMMS  <http://www.xmms.org>
# * mediastreamer (2.3.0 or higher)  <http://www.linphone.org/index.php/eng/code_review/mediastreamer2>
# * libmeanwhile  <http://meanwhile.sf.net>
# * libgadu (1.8.0 or higher)  <http://toxygen.net/libgadu/>

# Let cmake find libktorrent. Waiting for upstream fix in 4.5.1
  KDEDIRS="${libktorrent}";

  meta = {
    description = "KDE network utilities";
    longDescription = "Various network utilities for KDE such as a messenger client and network configuration interface";
    license = "GPL";
    kde = {
      name = "kdenetwork";
      version = "4.5.0";
    };
  };
}
