args @ { fetchurl, ... }:
rec {
  baseName = ''cffi'';
  version = ''cffi_0.23.0'';

  parasites = [ "cffi/c2ffi" "cffi/c2ffi-generator" ];

  description = ''The Common Foreign Function Interface'';

  deps = [ args."alexandria" args."babel" args."cl-json" args."cl-ppcre" args."trivial-features" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2020-07-15/cffi_0.23.0.tgz'';
    sha256 = ''1szpbg5m5fjq7bpkblflpnwmgz3ncsvp1y43g3jzwlk7yfxrwxck'';
  };

  packageName = "cffi";

  asdFilesToKeep = ["cffi.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi DESCRIPTION The Common Foreign Function Interface SHA256
    1szpbg5m5fjq7bpkblflpnwmgz3ncsvp1y43g3jzwlk7yfxrwxck URL
    http://beta.quicklisp.org/archive/cffi/2020-07-15/cffi_0.23.0.tgz MD5
    a43e3c440fc4f20494e6d2347887c963 NAME cffi FILENAME cffi DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-json FILENAME cl-json) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME trivial-features FILENAME trivial-features)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES (alexandria babel cl-json cl-ppcre trivial-features uiop)
    VERSION cffi_0.23.0 SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-toolchain
     cffi-uffi-compat)
    PARASITES (cffi/c2ffi cffi/c2ffi-generator)) */
