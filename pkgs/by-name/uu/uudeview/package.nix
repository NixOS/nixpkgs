{
  lib,
  stdenv,
  fetchFromGitHub,
  tcl,
  tk,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "uudeview";
  version = "0.5.20-unstable-2025-03-20";

  src = fetchFromGitHub {
    owner = "hannob";
    repo = "uudeview";
    rev = "7640bc56aa5016cdc9c139eb1ab3ec874e47c744";
    hash = "sha256-IdHxkrXe+2I+aJpZ0bhimXq4xEXE9HDXrL5DtCs7MKk=";
  };

  buildInputs = [
    tcl
    tk
  ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--enable-tk=${tk.dev}"
    "--enable-tcl=${tcl}"
  ];

  postPatch = ''
    substituteInPlace tcl/xdeview --replace "exec uuwish" "exec $out/bin/uuwish"
  '';

  meta = {
    description = "Nice and Friendly Decoder";
    homepage = "http://www.fpx.de/fp/Software/UUDeview/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.linux;
  };
}
