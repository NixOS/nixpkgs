args @ { fetchurl, ... }:
rec {
  baseName = ''cffi-toolchain'';
  version = ''cffi_0.23.0'';

  description = ''The CFFI toolchain'';

  deps = [ args."alexandria" args."babel" args."cffi" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2020-07-15/cffi_0.23.0.tgz'';
    sha256 = ''1szpbg5m5fjq7bpkblflpnwmgz3ncsvp1y43g3jzwlk7yfxrwxck'';
  };

  packageName = "cffi-toolchain";

  asdFilesToKeep = ["cffi-toolchain.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi-toolchain DESCRIPTION The CFFI toolchain SHA256
    1szpbg5m5fjq7bpkblflpnwmgz3ncsvp1y43g3jzwlk7yfxrwxck URL
    http://beta.quicklisp.org/archive/cffi/2020-07-15/cffi_0.23.0.tgz MD5
    a43e3c440fc4f20494e6d2347887c963 NAME cffi-toolchain FILENAME
    cffi-toolchain DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi trivial-features) VERSION cffi_0.23.0
    SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-uffi-compat cffi)
    PARASITES NIL) */
