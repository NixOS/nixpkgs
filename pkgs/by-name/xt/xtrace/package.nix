{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitLab,
  libX11,
  xauth,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "xtrace";
  version = "1.4.0";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "xtrace";
    rev = "xtrace-${version}";
    sha256 = "1yff6x847nksciail9jly41mv70sl8sadh0m5d847ypbjmxcwjpq";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];
  buildInputs = [ libX11 ];

  postInstall = ''
    wrapProgram "$out/bin/xtrace" \
        --prefix PATH ':' "${xauth}/bin"
  '';

  meta = with lib; {
    homepage = "https://salsa.debian.org/debian/xtrace";
    description = "Tool to trace X11 protocol connections";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = with platforms; linux;
    mainProgram = "xtrace";
  };
}
