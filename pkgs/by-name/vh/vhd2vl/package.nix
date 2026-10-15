{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  iverilog,
  which,
}:

stdenv.mkDerivation {
  pname = "vhd2vl";
  version = "0-unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "ldoolitt";
    repo = "vhd2vl";
    rev = "a6ed1b45ce88bf978f18e8f6fc419e853a6676b4";
    sha256 = "sha256-lFPGstQd7u5crEJz6bFbbMTmNoZgRFuHb3HVCDnzDYk=";
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

  meta = {
    description = "VHDL to Verilog converter";
    mainProgram = "vhd2vl";
    homepage = "https://github.com/ldoolitt/vhd2vl";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ matthuszagh ];
  };
}
