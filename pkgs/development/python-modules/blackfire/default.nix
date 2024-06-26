{ lib,
  stdenv,
  buildPythonPackage,
  python,
  fetchPypi,
}:

let
  format = "wheel";
  pyShortVersion = "cp" + builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  platforms = rec {
    aarch64-darwin = "macosx_11_0_arm64";
    aarch64-linux = "manylinux2014_aarch64";
    x86_64-darwin = "macosx_11_0_x86_64";
    x86_64-linux = "manylinux2014_x86_64";
  };
  platform = platforms.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  hashes = rec {
    cp309-aarch64-darwin = "sha256-zxgwy+s/6UT6qdxbzAR6bm8Xg8h0NnKo1XECVh6ojTU=";
    cp309-aarch64-linux = "sha256-IxJ/N6Wcz5g5xviPrXXRvSZYVnMYzfptqVR7N+aDHMc=";
    cp309-x86_64-darwin = "sha256-9skSDKL772iYxVMhS1MDsaitgkD5J4BDyqMLRYRFShU=";
    cp309-x86_64-linux = "sha256-laOQf/0nmM+FzNsvHzBWL3VI6b0FWijEgtAsaRDten0=";
    cp310-aarch64-darwin = "sha256-9kjQCcxp2S9dnTpss8Jj2WJ0aGehB67Y16yoMvczuXw=";
    cp310-aarch64-linux = "sha256-yTSIpwCyIled1/i4U0xSHWXWH3QGJH8QFpaj6d8C6+w=";
    cp310-x86_64-darwin = "sha256-i/Omx4khnPyYuhkddbjLFG7/tvRSCyDX68V+lE66RkM=";
    cp310-x86_64-linux = "sha256-L3QjijpgI0WizvxZ8cJK38drj7GzfZOTWbpJJqb5gWM=";
    cp311-aarch64-darwin = "sha256-3vjoI1l7IYU8j4IzxeWqtcT8D3ygYKCrOSKndruK8DE=";
    cp311-aarch64-linux = "sha256-lQIUNeSkORHHDPN8PUy7w/j5WUFtuHX/dANRFgiZTBg=";
    cp311-x86_64-darwin = "sha256-KrhoSHU6t+ML/GyYYB8osKbkf1VAA2ZnMsBqGqdU5Xs=";
    cp311-x86_64-linux = "sha256-fMTu3rPr/KqWXs1p4SDPJNqaAorhlL4FT61QmuPmh/A=";
    cp312-aarch64-darwin = "sha256-8TFUrrjdjupPpwGwoB4Ql4D3vzECRE0fZu8fzdvNDfc=";
    cp312-aarch64-linux = "sha256-mGCW2DuX78fsF+yHpOlFrb8Ba4+blaoxJyGFpHKFj0g=";
    cp312-x86_64-darwin = "sha256-j+rtdZciC5pZA+ususoB40boy6eTQU59Vc5v7cVW1dU=";
    cp312-x86_64-linux = "sha256-BojYfDIDbuduitMQU15+YcG2NmfxztZAfQrT5LaI+Ng=";
  };
  hash =
    hashes."${pyShortVersion}-${stdenv.system}"
      or (throw "Unsupported Python version: ${python.pythonVersion}");
in
buildPythonPackage rec {
  pname = "blackfire";
  version = "1.20.15";
  inherit format;

  src = fetchPypi {
    inherit pname version;
    python = pyShortVersion;
    abi = pyShortVersion;
    dist = pyShortVersion;
    inherit format platform hash;
  };

  pythonImportsCheck = [
    "blackfire"
  ];

  meta = {
    description = "Blackfire Python SDK";
    homepage = "https://github.com/blackfireio/python-sdk";
    license = with lib.licenses; [mit unfree];
    platforms = builtins.attrNames platforms;
    maintainers = with lib.maintainers; [ ];
  };
}
