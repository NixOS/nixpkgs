{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland
, wayland-protocols
, fetchpatch
, wayland-scanner
}:

stdenv.mkDerivation {
  pname = "wdomirror";
  version = "unstable-2021-01-08";

  src = fetchFromGitHub {
    owner = "progandy";
    repo = "wdomirror";
    rev = "e4a4934e6f739909fbf346cbc001c72690b5c906";
    sha256 = "1fz0sajhdjqas3l6mpik8w1k15wbv65hgh9r9vdgfqvw5l6cx7jv";
  };

  patches = [
    # https://github.com/progandy/wdomirror/pull/7
    (fetchpatch {
      url = "https://github.com/progandy/wdomirror/commit/142632208e9ea2b4a4ebd784532efdb8cad7b87c.patch";
      hash = "sha256-MG71IEwRAjjacAkRoB7Tn45+FbY7LAqTDkVJkoWuQUU=";
    })
  ];

  strictDeps = true;
  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];

  buildInputs = [ wayland wayland-protocols ];

  installPhase = ''
    runHook preInstall
    install -m755 -D wdomirror $out/bin/wdomirror
    runHook postInstall
  '';

  postPatch = ''
    substituteInPlace meson.build \
      --replace "werror=true" "werror=false"
  '';

  meta = with lib; {
    description = "Mirrors an output of a wlroots compositor to a window";
    homepage = "https://github.com/progandy/wdomirror";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jpas ];
    mainProgram = "wdomirror";
  };
}
