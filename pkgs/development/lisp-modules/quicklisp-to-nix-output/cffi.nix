args @ { fetchurl, ... }:
rec {
  baseName = ''cffi'';
  version = ''cffi_0.20.0'';

  parasites = [ "cffi/c2ffi" "cffi/c2ffi-generator" ];

  description = ''The Common Foreign Function Interface'';

  deps = [ args."alexandria" args."babel" args."cl-json" args."cl-ppcre" args."trivial-features" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2018-12-10/cffi_0.20.0.tgz'';
    sha256 = ''1jal7r0dqp0sc5wj8a97xjlvfvayymdp1w3172hdxfppddnhhm8z'';
  };

  packageName = "cffi";

  asdFilesToKeep = ["cffi.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi DESCRIPTION The Common Foreign Function Interface SHA256
    1jal7r0dqp0sc5wj8a97xjlvfvayymdp1w3172hdxfppddnhhm8z URL
    http://beta.quicklisp.org/archive/cffi/2018-12-10/cffi_0.20.0.tgz MD5
    94a8b377cf1ac7d8fc73dcc98f3420c6 NAME cffi FILENAME cffi DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-json FILENAME cl-json) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME trivial-features FILENAME trivial-features)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES (alexandria babel cl-json cl-ppcre trivial-features uiop)
    VERSION cffi_0.20.0 SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-toolchain
     cffi-uffi-compat)
    PARASITES (cffi/c2ffi cffi/c2ffi-generator)) */
