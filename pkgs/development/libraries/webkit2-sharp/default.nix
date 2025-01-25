{
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  gtk-sharp-3_0,
  lib,
  libxslt,
  mono,
  pkg-config,
  webkitgtk,
}:

stdenv.mkDerivation rec {
  pname = "webkit2-sharp";
  version = "a59fd76dd730432c76b12ee6347ea66567107ab9";

  src = fetchFromGitHub {
    owner = "hbons";
    repo = "webkit2-sharp";
    rev = version;
    sha256 = "sha256:0a7vx81zvzn2wq4q2mqrxvlps1mqk28lm1gpfndqryxm4iiw28vc";
  };

  nativeBuildInputs = [
    autoreconfHook
    libxslt
    mono
    pkg-config
  ];

  buildInputs = [
    gtk-sharp-3_0
    webkitgtk
  ];

  postPatch = ''
    # Workaround build failure with WebKitGTK 2.40.0
    # https://github.com/hbons/webkit2-sharp/issues/6
    substituteInPlace sources/webkit2-sharp-api.raw --replace \
      '<field cname="parentInstance" access="public" writeable="false" readable="true" name="ParentInstance" type="GtkContainer*"/>' \
      '<field cname="parent" access="public" writeable="false" readable="true" name="Parent" type="GtkContainer*"/>'
  '';

  ac_cv_path_MONODOCER = "no";
  installFlags = [ "GAPIXMLDIR=/tmp/gapixml" ];

  passthru = {
    inherit webkitgtk;
  };

  meta = {
    description = "C# bindings for WebKit 2 with GTK+ 3";
    homepage = "https://github.com/hbons/webkit2-sharp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kevincox ];
  };
}
