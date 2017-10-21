{ gnome3, fetchFromGitHub, autoconf, automake, gtk_doc, gettext, libtool, gperf }:

gnome3.vte.overrideAttrs (oldAttrs: rec {
  name = "vte-ng-${version}";
  version = "0.46.1.a";

  src = fetchFromGitHub {
    owner = "thestinger";
    repo = "vte-ng";
    rev = version;
    sha256 = "125fpibid1liz50d7vbxy71pnm8b01x90xnkr4z3419b90lybr0a";
  };

  # The patches apply the changes from https://github.com/GNOME/vte/pull/7 and
  # can be removed once the commits are merged into vte-ng.
  patches = [
    ./fix_g_test_init_calls.patch
    ./fix_vteseq_n_lookup_declaration.patch
  ];

  preConfigure = oldAttrs.preConfigure + "; ./autogen.sh";

  nativeBuildInputs = oldAttrs.nativeBuildInputs or []
    ++ [ gtk_doc autoconf automake gettext libtool gperf ];
})
