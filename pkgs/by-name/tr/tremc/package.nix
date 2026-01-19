{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  x11Support ? !stdenv.hostPlatform.isDarwin,
  xclip ? null,
  pbcopy ? null,
  useGeoIP ? false, # Require /var/lib/geoip-databases/GeoIP.dat
}:
let
  version = "0.9.5";
in
python3Packages.buildPythonApplication {
  pname = "tremc";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "tremc";
    repo = "tremc";
    tag = version;
    hash = "sha256-t7GH3flTLN8O+nnv/kwwzu5x3VoCyF11bqb1EJ8LQs8=";
  };

  pythonPath =
    with python3Packages;
    [
      ipy
      pyperclip
    ]
    ++ lib.optional useGeoIP geoip;

  dontBuild = true;
  doCheck = false;

  makeFlags = [ "DESTDIR=${placeholder "out"}" ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath (lib.optional x11Support xclip ++ lib.optional stdenv.hostPlatform.isDarwin pbcopy)
    }"
  ];

  meta = {
    description = "Curses interface for transmission";
    mainProgram = "tremc";
    homepage = "https://github.com/tremc/tremc";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kashw2 ];
  };
}
