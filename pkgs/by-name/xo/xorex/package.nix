{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "xorex";
  version = "0.3.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Neo23x0";
    repo = "xorex";
    rev = version;
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

  meta = with lib; {
    description = "XOR Key Extractor";
    mainProgram = "xorex";
    homepage = "https://github.com/Neo23x0/xorex";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
