{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  iverilog,
  which,
}:

stdenv.mkDerivation rec {
  pname = "vhd2vl";
  version = "unstable-2022-12-26";

  src = fetchFromGitHub {
    owner = "ldoolitt";
    repo = pname;
    rev = "869d442987dff6b9730bc90563ede89c1abfd28f";
    sha256 = "sha256-Hz2XkT5m4ri5wVR2ciL9Gx73zr+RdW5snjWnUg300c8=";
  };

  nativeBuildInputs = [
    bison
    flex
    which
  ];

  buildInputs = [
    iverilog
  ];

  # the "translate" target both (a) builds the software and (b) runs
  # the tests (without validating the results)
  buildTargets = [ "translate" ];

  # the "diff" target examines the test results
  checkTarget = "diff";

  installPhase = ''
    runHook preInstall
    install -D -m755 src/vhd2vl $out/bin/vhd2vl
    runHook postInstall
  '';

  meta = with lib; {
    description = "VHDL to Verilog converter";
    mainProgram = "vhd2vl";
    homepage = "https://github.com/ldoolitt/vhd2vl";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
