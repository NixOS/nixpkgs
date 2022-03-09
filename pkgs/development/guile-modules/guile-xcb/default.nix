{ lib
, stdenv
, fetchFromGitHub
, guile
, pkg-config
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "guile-xcb";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "mwitmer";
    repo = pname;
    rev = version;
    hash = "sha256-8iaYil2wiqnu9p7Gj93GE5akta1A0zqyApRwHct5RSs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    guile
    texinfo
  ];

  configureFlags = [
    "--with-guile-site-dir=$out/share/guile/site"
    "--with-guile-site-ccache-dir=$out/share/guile/site"
  ];

  meta = with lib; {
    homepage = "https://github.com/mwitmer/guile-xcb";
    description = "XCB bindings for Guile";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
