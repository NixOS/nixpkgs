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
  version = "u094";
in
python3Packages.buildPythonApplication {
  pname = "tremc";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "tremc";
    repo = "tremc";
    tag = version;
    hash = "sha256-nsznu4CaLtq3mhDKtDrx8IKbO5grr571YR6NT3EeMbQ=";
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
