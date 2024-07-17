{
  lib,
  buildPerlPackage,
  fetchFromGitHub,
  fetchpatch,
  GD,
  IPCShareLite,
  JSON,
  LWP,
  mapnik,
  nix-update-script,
}:

buildPerlPackage rec {
  pname = "Tirex";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = "tirex";
    rev = "refs/tags/v${version}";
    hash = "sha256-p2P19tifA/AvJatTzboyhtt7W1SwKJQzqpU4oDalfhU=";
  };

  patches = [
    # https://github.com/openstreetmap/tirex/pull/54
    (fetchpatch {
      url = "https://github.com/openstreetmap/tirex/commit/da0c5db926bc0939c53dd902a969b689ccf9edde.patch";
      hash = "sha256-bnL1ZGy8ZNSZuCRbZn59qRVLg3TL0GjFYnhRKroeVO0=";
    })
  ];

  buildInputs = [
    GD
    IPCShareLite
    JSON
    LWP
    mapnik
  ] ++ mapnik.buildInputs;

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
