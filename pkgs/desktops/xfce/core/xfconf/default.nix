{ lib
, mkXfceDerivation
, fetchpatch
, libxfce4util
, gobject-introspection
, vala
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.18.2";

  sha256 = "sha256-FVNkcwOS4feMocx3vYhuWNs1EkXDrM1FaKkMhIOuPHI=";

  patches = [
    # fixes a segfault, can likely be removed with 4.18.3,
    # see https://gitlab.xfce.org/xfce/xfconf/-/issues/35#note_81151
    (fetchpatch {
      name = "cache-fix-uncached-value.patch";
      url = "https://gitlab.xfce.org/xfce/xfconf/-/commit/03f7ff961fd46c9141aba624a278e19de0bf3211.diff";
      hash = "sha256-n9Wvt7NfKMxs2AcjUWgs4vZgzLUG9jyEVTZxINko4h8=";
    })
  ];

  nativeBuildInputs = [ gobject-introspection vala ];

  buildInputs = [ libxfce4util ];

  meta = with lib; {
    description = "Simple client-server configuration storage and query system for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
