{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  python3,
  pango,
  glibmm,
  cairomm,
  gnome,
  ApplicationServices,
}:

stdenv.mkDerivation rec {
  pname = "pangomm";
  version = "2.42.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-GyTJJiSuEnXMtXdYF10198Oa0zQtjAtLpg8NmEnS0Io=";
  };

  patches = [
    # Fixes a missing include leading to build failures while compiling `attrlist.cc` (as outlined by @dslm4515 [1])
    # Note that the files in that directory are generated and not tracked in Git [2], which is why we can't simply
    # try to cherry-pick an upstream patch from future versions.
    # [1]: https://github.com/dslm4515/BMLFS/issues/16#issuecomment-914624797
    # [2]: https://github.com/GNOME/pangomm/tree/master/untracked
    ./2.42.2-add-missing-include-attrlist.cc.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs =
    [
      pkg-config
      meson
      ninja
      python3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      ApplicationServices
    ];
  propagatedBuildInputs = [
    pango
    glibmm
    cairomm
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    broken =
      (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || stdenv.hostPlatform.isDarwin;
    description = "C++ interface to the Pango text rendering library";
    homepage = "https://www.pango.org/";
    license = with licenses; [
      lgpl2
      lgpl21
    ];
    maintainers = with maintainers; [
      lovek323
      raskin
    ];
    platforms = platforms.unix;

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK widget toolkit.
      Pango forms the core of text and font handling for GTK.
    '';
  };
}
