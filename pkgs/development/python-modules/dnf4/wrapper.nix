{ lib
, wrapPython
, python3
, stdenv
, dnf-plugins-core
, plugins ? [ dnf-plugins-core ]
}:
let
  pluginPaths = map (p: "${p}/${python3.sitePackages}/dnf-plugins") plugins;

  dnf4-unwrapped = python3.pkgs.dnf4;
in

stdenv.mkDerivation {
  pname = "dnf4";
  inherit (dnf4-unwrapped) version;

  outputs = [ "out" "man" "py" ];

  dontUnpack = true;

  nativeBuildInputs = [
    wrapPython
  ];

  propagatedBuildInputs = [
    dnf4-unwrapped
  ] ++ plugins;

  makeWrapperArgs = lib.optional (plugins != [ ]) ''--add-flags "--setopt=pluginpath=${lib.concatStringsSep "," pluginPaths}"'';

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
    priority = (dnf4-unwrapped.meta.priority or 0) - 1;
  };
}
