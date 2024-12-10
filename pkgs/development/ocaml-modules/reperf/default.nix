{
  buildDunePackage,
  fetchFromGitHub,
  lib,
  printbox-text,
  reason,
}:

buildDunePackage rec {
  pname = "reperf";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "bryphe";
    repo = "reperf";
    rev = "68ef2f96899c09e6ac7d929b0375f7a806aee067";
    sha256 = "sha256-ASujTsH4eDAYLNalB9Xt1p3C8x+FI0kMldZBYaXMCWc=";
  };

  postPatch = ''
    substituteInPlace src/dune --replace "printbox" "printbox-text"
  '';

  nativeBuildInputs = [ reason ];

  propagatedBuildInputs = [
    printbox-text
  ];

  meta = with lib; {
    description = "Native Reason + JSOO cross-platform performance benchmarking tools";
    longDescription = ''
      Inspired by the core_bench tools from Janestreet.

      reperf helps with:
      * Timing: time spent in a code block
      * Call count: frequency of code-path calls
      * Allocations: code-block impact to garbage collector

      Supports benchmarks, which are test cases that exercise performance scenarios.
      Outputs a JSON performance report, and compare it with previous iterations - and fail if a regression is detected.
    '';
    homepage = "https://github.com/bryphe/reperf";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
