{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitLab,
  libX11,
  xauth,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtrace";
  version = "1.4.0";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "xtrace";
    rev = "xtrace-${finalAttrs.version}";
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

  meta = {
    homepage = "https://salsa.debian.org/debian/xtrace";
    description = "Tool to trace X11 protocol connections";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
    mainProgram = "xtrace";
  };
})
