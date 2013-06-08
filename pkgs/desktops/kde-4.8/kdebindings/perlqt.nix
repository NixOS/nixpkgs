{ kde, cmake, smokeqt, perl }:

kde {
  buildInputs = [ smokeqt perl ];
  nativeBuildInputs = [ cmake ];

  patches =
    # The order is important
    [ ./perlqt-include-smokeqt.patch ./perlqt-rewrite-FindPerlMore.patch
      ./perlqt-use-site-arch-install-dir.patch
    ];

  meta = {
    description = "Perl bindings for Qt library";
  };
}
