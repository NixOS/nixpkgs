{ stdenv, fetchFromGitHub, glib, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-hibernate-status";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "arelange";
    repo = "gnome-shell-extension-hibernate-status";
    rev = "v${version}";
    sha256 = "0418zcm9khgr7y5al51ffq0wbnajb8717589ci4207aaizgwipp8";
  };

  uuid = "hibernate-status@dromi";

  nativeBuildInputs = [
    glib
  ];

  buildPhase = ''
    glib-compile-schemas --strict --targetdir=schemas/ schemas
  '';

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp *.js $out/share/gnome-shell/extensions/${uuid}
    cp -r schemas $out/share/gnome-shell/extensions/${uuid}
    cp metadata.json $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "A hibernate/hybrid suspend button in status menu";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ericdallo ];
    platforms = gnome3.gnome-shell.meta.platforms;
    homepage = https://github.com/arelange/gnome-shell-extension-hibernate-status;
  };
}
