/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cffi-uffi-compat";
  version = "cffi_0.23.0";

  description = "UFFI Compatibility Layer for CFFI";

  deps = [ args."alexandria" args."babel" args."cffi" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cffi/2020-07-15/cffi_0.23.0.tgz";
    sha256 = "1szpbg5m5fjq7bpkblflpnwmgz3ncsvp1y43g3jzwlk7yfxrwxck";
  };

  packageName = "cffi-uffi-compat";

  asdFilesToKeep = ["cffi-uffi-compat.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi-uffi-compat DESCRIPTION UFFI Compatibility Layer for CFFI
    SHA256 1szpbg5m5fjq7bpkblflpnwmgz3ncsvp1y43g3jzwlk7yfxrwxck URL
    http://beta.quicklisp.org/archive/cffi/2020-07-15/cffi_0.23.0.tgz MD5
    a43e3c440fc4f20494e6d2347887c963 NAME cffi-uffi-compat FILENAME
    cffi-uffi-compat DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi trivial-features) VERSION cffi_0.23.0
    SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-toolchain cffi)
    PARASITES NIL) */
