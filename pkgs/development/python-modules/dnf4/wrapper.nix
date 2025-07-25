{
  lib,
  stdenv,
  python3Packages,
  plugins ? [ python3Packages.dnf-plugins-core ],
}:
let
  pluginPaths = map (p: "${p}/${python3Packages.python.sitePackages}/dnf-plugins") plugins;

  dnf4-unwrapped = python3Packages.dnf4;
in

stdenv.mkDerivation {
  pname = "dnf4";
  inherit (dnf4-unwrapped) version;

  outputs = [
    "out"
    "man"
    "py"
  ];

  dontUnpack = true;

  nativeBuildInputs = [ python3Packages.wrapPython ];

  propagatedBuildInputs = [ dnf4-unwrapped ] ++ plugins;

  makeWrapperArgs = lib.optional (
    plugins != [ ]
  ) ''--add-flags "--setopt=pluginpath=${lib.concatStringsSep "," pluginPaths}"'';

  installPhase = ''
    runHook preInstall

    cp -R ${dnf4-unwrapped} $out
    cp -R ${dnf4-unwrapped.py} $py
    cp -R ${dnf4-unwrapped.man} $man

    runHook postInstall
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  passthru = {
    unwrapped = dnf4-unwrapped;
  };

  meta = dnf4-unwrapped.meta // {
    priority = (dnf4-unwrapped.meta.priority or lib.meta.defaultPriority) - 1;
  };
}
