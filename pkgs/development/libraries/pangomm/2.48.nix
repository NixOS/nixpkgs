{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  python3,
  pango,
  glibmm_2_68,
  cairomm_1_16,
  gnome,
  ApplicationServices,
}:

stdenv.mkDerivation rec {
  pname = "pangomm";
  version = "2.52.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-NKE0EmpkhP8S93Q1jDbsxE0OnfCU4bg3ltl3S7fSSUc=";
  };

  nativeBuildInputs =
    [
      pkg-config
      meson
      ninja
      python3
    ]
    ++ lib.optionals stdenv.isDarwin [
      ApplicationServices
    ];

  propagatedBuildInputs = [
    pango
    glibmm_2_68
    cairomm_1_16
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "${pname}_2_48";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "C++ interface to the Pango text rendering library";
    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK widget toolkit.
      Pango forms the core of text and font handling for GTK.
    '';
    homepage = "https://www.pango.org/";
    license = licenses.lgpl21Plus;
    maintainers =
      teams.gnome.members
      ++ (with maintainers; [
        lovek323
        raskin
      ]);
    platforms = platforms.unix;
  };
}
