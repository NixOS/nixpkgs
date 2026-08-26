{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "xorex";
  version = "0.3.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Neo23x0";
    repo = "xorex";
    rev = finalAttrs.version;
    sha256 = "rBsOSXWnHRhpLmq20XBuGx8gGBM8ouMyOISkbzUcvE4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    chmod +x xorex.py
    mv xorex.py $out/bin/xorex

    runHook postInstall
  '';

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    pefile
  ];

  meta = {
    description = "XOR Key Extractor";
    mainProgram = "xorex";
    homepage = "https://github.com/Neo23x0/xorex";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
