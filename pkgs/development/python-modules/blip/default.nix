{ stdenv
, fetchFromGitHub
, timm
, transformers
, fairscale
}:

stdenv.mkDerivation {
  pname = "blip";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "salesforce";
    repo = "BLIP";
    rev = "48211a1594f1321b00f14c9f7a5b4813144b2fb9";
    sha256 = "sha256-0IO+3M/Gy4VrNBFYYgZB2CzWhT3PTGBXNKPad61px5k=";
  };


  buildPhase = ''
    mkdir -p $out/lib/python3.10/site-packages
    cp -R ./ $out/lib/python3.10/site-packages/blip/
  '';

  dontInstall = true;

  propagatedBuildInputs = [
    timm
    transformers
    fairscale
    #pycocoevalcap
  ];

  # pythonImportsCheck = [
  #  "blip"
  #];

  # TODO FIXME
  doCheck = false;

  meta = {
    description =
      "Bootstrapping Language-Image Pre-training for Unified Vision-Language Understanding and Generation";
    homepage = "https://github.com/salesforce/BLIP";
  };
}

