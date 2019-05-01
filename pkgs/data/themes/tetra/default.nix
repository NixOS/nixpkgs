{ stdenv, fetchFromGitHub, gtk3, sassc }:

stdenv.mkDerivation rec {
  pname = "tetra-gtk-theme";
  version = "201905";

  src = fetchFromGitHub {
    owner  = "hrdwrrsk";
    repo   = pname;
    rev    = version;
    sha256 = "1j2w8na564f5yjm5am7843hq5qk28h1rq8rcbak4xsygdc3lbsfi";
  };

  preBuild = ''
    # Shut up inkscape's warnings
    export HOME="$NIX_BUILD_ROOT"
  '';

  nativeBuildInputs = [ sassc ];
  buildInputs = [ gtk3 ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p $out/share/themes
    ./install.sh -d $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "Adwaita-based gtk+ theme with design influence from elementary OS and Vertex gtk+ theme";
    homepage    = https://github.com/hrdwrrsk/tetra-gtk-theme;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
    platforms   = platforms.linux;
  };
}
