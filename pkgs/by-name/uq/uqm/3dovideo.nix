{
  stdenv,
  lib,
  requireFile,
  writeText,
  fetchFromGitHub,
  haskellPackages,
}:

let
  makeSpin =
    num:
    let
      padded = (lib.optionalString (lib.lessThan num 10) "0") + toString num;
    in
    "slides.spins.${padded} = 3DOVID:"
    + "addons/3dovideo/spins/ship${padded}.duk:"
    + "addons/3dovideo/spins/spin.aif:"
    + "addons/3dovideo/spins/ship${padded}.aif:89";

  videoRMP = writeText "3dovideo.rmp" (
    ''
      slides.ending = 3DOVID:addons/3dovideo/ending/victory.duk
      slides.intro = 3DOVID:addons/3dovideo/intro/intro.duk
    ''
    + lib.concatMapStrings makeSpin (lib.range 0 24)
  );

  helper =
    with haskellPackages;
    mkDerivation rec {
      pname = "uqm3donix";
      version = "0.1.0.0";

      src = fetchFromGitHub {
        owner = "aszlig";
        repo = "uqm3donix";
        rev = "v${version}";
        hash = "sha256-rK30u2PBysiSGSA9829F1Nom/wtoVN6rGTBneRKeWEw=";
      };

      isLibrary = false;
      isExecutable = true;

      buildDepends = [
        base
        binary
        bytestring
        filepath
        tar
      ];

      description = "Extract video files from a Star Control II 3DO image";
      license = lib.licenses.bsd3;
    };

in
stdenv.mkDerivation {
  name = "uqm-3dovideo";

  src = requireFile rec {
    name = "videos.tar";
    sha256 = "044h0cl69r0kc43vk4n0akk0prwzb7inq324h5yfqb38sd4zkds1";
    message = ''
      In order to get the intro and ending sequences from the 3DO version, you
      need to have the original 3DO Star Control II CD. Create an image from
      the CD and use uqm3donix* to extract a tarball with the videos from it.
      The reason for this is because the 3DO uses its own proprietary disk
      format.

      Save the file as videos.tar and use "nix-prefetch-url file://\$PWD/${name}" to
      add it to the Nix store.

      [*] ${helper}/bin/uqm3donix CDIMAGE ${name}
    '';
  };

  buildCommand = ''
    mkdir -vp "$out"
    tar xf "$src" -C "$out" --strip-components=3
    cp "${videoRMP}" "$out/3dovideo.rmp"
  '';
}
