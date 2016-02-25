{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, kitemviews
, kio
, kdesignerplugin
, kdbusaddons
, kitemmodels
, kguiaddons
, kiconthemes
, akonadi
, kmime
, shared_mime_info
, phonon
, kcontacts
, kcalcore
, kdelibs4support
, libical
, kldap
, openldap
, cyrus_sasl
, kmbox
, boost
}:

kdeApp {
  name = "kdepimlibs";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];

  buildInputs = [
    akonadi
    kcontacts
    kitemviews
    kio
    kdesignerplugin
    kdbusaddons
    kitemmodels
    kguiaddons
    kiconthemes
    kmime
    shared_mime_info
    phonon
    kcalcore
    kdelibs4support
    libical
    kldap
    openldap
    cyrus_sasl
    kmbox
    boost
  ];

  postInstall = ''
    wrapQtProgram "$out/bin/akonadi2xml"
    wrapQtProgram "$out/bin/akonadiselftest"
  '';

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
