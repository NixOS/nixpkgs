args @ { fetchurl, ... }:
rec {
  baseName = ''cffi-grovel'';
  version = ''cffi_0.23.0'';

  description = ''The CFFI Groveller'';

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-toolchain" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2020-07-15/cffi_0.23.0.tgz'';
    sha256 = ''1szpbg5m5fjq7bpkblflpnwmgz3ncsvp1y43g3jzwlk7yfxrwxck'';
  };

  packageName = "cffi-grovel";

  asdFilesToKeep = ["cffi-grovel.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi-grovel DESCRIPTION The CFFI Groveller SHA256
    1szpbg5m5fjq7bpkblflpnwmgz3ncsvp1y43g3jzwlk7yfxrwxck URL
    http://beta.quicklisp.org/archive/cffi/2020-07-15/cffi_0.23.0.tgz MD5
    a43e3c440fc4f20494e6d2347887c963 NAME cffi-grovel FILENAME cffi-grovel DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi cffi-toolchain trivial-features)
    VERSION cffi_0.23.0 SIBLINGS
    (cffi-examples cffi-libffi cffi-tests cffi-toolchain cffi-uffi-compat cffi)
    PARASITES NIL) */
