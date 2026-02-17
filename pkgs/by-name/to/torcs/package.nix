{
  stdenv,
  symlinkJoin,
  torcs-without-data,
}:
let
  # This package is split into two parts because the complete package includes
  # the game data, which takes up a lot of space and is not worth serving from
  # the official cache. The compiled program gets built by Hydra and cached,
  # while the game data does not and gets handled locally instead.
  torcs-data = stdenv.mkDerivation (finalAttrs: {
    pname = "torcs-data";
    inherit (torcs-without-data)
      version
      src
      buildInputs
      ;

    dontBuild = true;

    installTargets = "export datainstall";
    postInstall = ''
      install -D -m644 Ticon.png $out/share/pixmaps/torcs.png
      install -D -m644 torcs.desktop $out/share/applications/torcs.desktop
    '';

    meta.hydraPlatforms = [ ];
  });
in
symlinkJoin {
  pname = "torcs";
  inherit (torcs-without-data)
    version
    ;

  paths = [
    torcs-without-data
    torcs-data
  ];

  postBuild = ''
    cp --remove-destination $(realpath $out/bin/torcs) $out/bin/torcs
    substituteInPlace $out/bin/torcs \
      --replace-fail "${torcs-without-data}" "$out"
  '';

  meta = torcs-without-data.meta // {
    description = "Car racing game";
    hydraPlatforms = [ ];
  };
}
