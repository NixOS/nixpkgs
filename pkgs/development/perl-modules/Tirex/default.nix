{
  lib,
  buildPerlPackage,
  fetchFromGitHub,
  GD,
  IPCShareLite,
  JSON,
  LWP,
  mapnik,
  boost,
  nix-update-script,
  pkg-config,
}:

buildPerlPackage rec {
  pname = "Tirex";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "tirex";
    tag = "v${version}";
    hash = "sha256-tFDyN3slj9ipa9JPB6f+mnzMIW926vOge4ZSbmxjtiE=";
  };

  patches = [
    # Support Mapnik >= v4.0.0 (no more mapnik-config)
    ./use-pkg-config.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    GD
    IPCShareLite
    JSON
    LWP
    mapnik
    boost
  ]
  ++ mapnik.buildInputs;

  installPhase = ''
    install -m 755 -d $out/usr/libexec
    make install DESTDIR=$out INSTALLOPTS=""
    mv $out/$out/lib $out/$out/share $out
    rmdir $out/$out $out/nix/store $out/nix
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for running a map tile server";
    homepage = "https://wiki.openstreetmap.org/wiki/Tirex";
    maintainers = with lib.maintainers; [ jglukasik ];
    license = with lib.licenses; [ gpl2Only ];
  };
}
