{ pkgs          ? (import <nixpkgs> {}).pkgs
, lib           ? pkgs.lib
, stdenv        ? pkgs.stdenv
}:

let

  nixpkgs = pkgs.fetchFromGitHub {
    owner = "peti";
    repo = "nixpkgs";
    rev = "b558bfa7d1e820904ff9d7bbc1f02ad51f690e34";
    sha256 = "1n1hicnn5mybd9cm7s2my5ayphsy0hhjv6bc4xcb1v9rpcm8pm16";
  };

  cabal2nix = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "cabal2nix";
    rev = "116145753cbf05572c127e00d8616385f8faa378";
    sha256 = "16zvxs2hjv7wvl1hmwq3v272rc9r6ind2vlcvdx29f3risxpjzkp";
  };

  hackage = pkgs.fetchFromGitHub {
    owner = "commercialhaskell";
    repo = "all-cabal-hashes";
    rev = "85f28bd0d000706c29f78275100dddd7c1c6c2f6";
    sha256 = "0w41lzkjvndcpscn5lyb8vvxpvq0kbg5ggdsk31167psa1g32hrz";
  };

  lts-haskell = pkgs.fetchFromGitHub {
    owner = "fpco";
    repo = "lts-haskell";
    rev = "89c3b45370ec1742d9e029ff4e5271316031b84b";
    sha256 = "0w3cz19g0h8dfxjpwf28rzj0xska11cbn5in5835ss2ypmbr2lwr";
  };

  stackage-nightly = pkgs.fetchFromGitHub {
    owner = "fpco";
    repo = "stackage-nightly";
    rev = "98e337bf6bf8efb772babe252e3f0027d8b6f859";
    sha256 = "1dmc8y72np2np3zrvdl61x539yw3qi4fpyyswib29j0h90pwj93p";
  };

  haskellPackages = pkgs.haskell.packages.bootstrap.override {
    overrides = self: super: {
      distribution-nixpkgs = super.distribution-nixpkgs.overrideDerivation (old: { src = cabal2nix; });
      cabal2nix = super.cabal2nix.overrideDerivation (old: { src = cabal2nix; });
      hackage2nix = super.hackage2nix.overrideDerivation (old: { src = cabal2nix; });
    };
  };

in

stdenv.mkDerivation {
  name = "haskell-update-0";
  buildInputs = [ haskellPackages.hackage2nix pkgs.nix ];
  src = [ nixpkgs ];
  buildPhase = ''
    # Processing Hackage requires UTF-8 support.
    export LANG="en_US.UTF-8"
    ${lib.optionalString stdenv.isLinux ''export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive"''}

    # hackage2nix runs nix-env to determine the set of visible package names.
    export NIX_STORE_DIR="$TMPDIR/nix/store" NIX_STATE_DIR="$TMPDIR/nix/var"

    # Build the preferred-versions file.
    for i in "${hackage}/"*/preferred-versions; do
      cat >>$TMPDIR/preferred-versions "$i"
      echo >>$TMPDIR/preferred-versions
    done

    # Generate the updated Haskell package set and LTS configuration files.
    hackage2nix +RTS -M6G -RTS \
      --nixpkgs="$PWD" --preferred-versions="$TMPDIR/preferred-versions" \
      --hackage="${hackage}" --lts-haskell="${lts-haskell}" \
      --stackage-nightly="${stackage-nightly}"
  '';

  doCheck = true;
  checkPhase = ''
    # Verify that all Haskell packages still evaluate properly.
    nix-env -qaP -f "$PWD" -A haskellPackages >/dev/null
  '';

  installPhase = ''
    mkdir -p "$out"
    cp pkgs/development/haskell-modules/hackage-packages.nix "$out/"
    cp pkgs/development/haskell-modules/configuration-lts-*.nix "$out/"
  '';

}
