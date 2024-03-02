{ stdenv, lib, fetchurl, fetchpatch, fixDarwinDylibNames, testers, buildPackages }:

let
  make-icu = (import ./make-icu.nix) {
    inherit stdenv lib buildPackages fetchurl fixDarwinDylibNames testers;
  };
in
{
  icu74 = make-icu {
    version = "74.2";
    hash = "sha256-aNsIIhKpbW9T411g9H04uWLp+dIHp0z6x4Apro/14Iw=";
  };
  icu73 = make-icu {
    version = "73.2";
    hash = "sha256-gYqAcS7TyqzZtlIwXgGvx/oWfm8ulJltpEuQwqtgTOE=";
  };
  icu72 = make-icu {
    version = "72.1";
    hash = "sha256-otLTghcJKn7VZjXjRGf5L5drNw4gGCrTJe3qZoGnHWg=";
  };
  icu71 = make-icu {
    version = "71.1";
    hash = "sha256-Z6fm5R9h+vEwa2k1Mz4TssSKvY2m0vRs5q3KJLHiHr8=";
  };
  icu70 = make-icu {
    version = "70.1";
    hash = "sha256-jSBUKMF78Tu1NTAGae0oszihV7HAGuZtMdDT4tR8P9U=";
  };
  icu69 = make-icu {
    version = "69.1";
    hash = "sha256-TLp7es0dPELES7DBS+ZjcJjH+vKzMM6Ha8XzuRXQl0U=";
  };
  icu68 = make-icu {
    version = "68.2";
    hash = "sha256-x5GT3uOQeiGZuClqk7UsXLdDMsJvPRZyaUh2gNR51iU=";
  };
  icu67 = make-icu {
    version = "67.1";
    hash = "sha256-lKgM1vJRpTvSqZf28bWsZlP+eR36tm4esCJ3QPuG1dw=";
  };
  icu66 = make-icu {
    version = "66.1";
    hash = "sha256-UqPyIJq5VVnBzwoU8kM4AB84lhW/AOJYXvPbxD7PCi4=";
  };
  icu64 = make-icu {
    version = "64.2";
    hash = "sha256-Yn1dhHjm2W/IyQ/tSFEjkHmlYaaoueSLCJLyToLTHWw=";
  };
  icu63 = make-icu {
    version = "63.1";
    hash = "sha256-BcSQtpRU/OWGC36OKCEjFnSvChHX7y/r6poyUSmYy50=";
    patches = [
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1499398
      (fetchpatch {
        url = "https://github.com/unicode-org/icu/commit/8baff8f03e07d8e02304d0c888d0bb21ad2eeb01.patch";
        sha256 = "1awfa98ljcf95a85cssahw6bvdnpbq5brf1kgspy14w4mlmhd0jb";
      })
    ];
    patchFlags = [ "-p3" ];
  };
  icu60 = make-icu {
    version = "60.2";
    hash = "sha256-8HPqjzW5JtcLsz5ld1CKpkKosxaoA/Eb4grzhIEdtBg=";
  };
  icu58 = make-icu {
    version = "58.2";
    hash = "sha256-KwpEEBU6myDeDiDH2LZgSacq7yRLU2g9DXUhNxaD2gw=";
    patches = [
      (fetchurl {
        url = "http://bugs.icu-project.org/trac/changeset/39484?format=diff";
        name = "icu-changeset-39484.diff";
        sha256 = "0hxhpgydalyxacaaxlmaddc1sjwh65rsnpmg0j414mnblq74vmm8";
      })
    ];
    patchFlags = [ "-p4" ];
  };
}
