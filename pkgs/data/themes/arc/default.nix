{ stdenv, fetchFromGitHub, sassc, autoreconfHook, pkgconfig, gtk3, gnome3
, gtk-engine-murrine, optipng, inkscape }:

stdenv.mkDerivation rec {
  pname = "arc-theme";
  version = "20190917";

  src = fetchFromGitHub {
    owner  = "arc-design";
    repo   = pname;
    rev    = version;
    sha256 = "1qgpk4p2hi5hd4yy0hj93kq1vs0b32wb8qkaj1wi90c8gwddq5wa";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    sassc
    optipng
    inkscape
    gtk3
  ];

  propagatedUserEnvPkgs = [
    gnome3.gnome-themes-extra
    gtk-engine-murrine
  ];

  enableParallelBuilding = true;

  preBuild = ''
    # Shut up inkscape's warnings about creating profile directory
    export HOME="$NIX_BUILD_ROOT"
  '';

  configureFlags = [
    "--disable-gnome-shell" # 3.36 not supported
    "--disable-unity"
  ];

  postInstall = ''
    install -Dm644 -t $out/share/doc/${pname} AUTHORS *.md
  '';

  meta = with stdenv.lib; {
    description = "Flat theme with transparent elements for GTK 3, GTK 2 and Gnome Shell";
    homepage    = "https://github.com/arc-design/arc-theme";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ simonvandel romildo ];
    platforms   = platforms.linux;
    broken = true; # since libsass 3.6.3
  };
}
