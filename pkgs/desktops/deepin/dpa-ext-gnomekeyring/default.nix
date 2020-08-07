{ stdenv
, fetchFromGitHub
, pkgconfig
, qmake
, qttools
, gnome3
, dde-polkit-agent
, deepin
}:

stdenv.mkDerivation rec {
  pname = "dpa-ext-gnomekeyring";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "032m481sx8q25z10jbja7ix1x9z2a629c86lf9b5wx3q9jb00dkq";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dde-polkit-agent
    gnome3.libgnome-keyring
  ];

  postPatch = ''
    searchHardCodedPaths
    patchShebangs translate_generation.sh
    fixPath $out /usr dpa-ext-gnomekeyring.pro gnomekeyringextention.cpp
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "GNOME keyring extension for dde-polkit-agent";
    homepage = "https://github.com/linuxdeepin/dpa-ext-gnomekeyring";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
