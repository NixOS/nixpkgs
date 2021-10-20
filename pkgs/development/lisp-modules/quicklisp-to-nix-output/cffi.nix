/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cffi";
  version = "cffi_0.24.1";

  parasites = [ "cffi/c2ffi" "cffi/c2ffi-generator" ];

  description = "The Common Foreign Function Interface";

  deps = [ args."alexandria" args."babel" args."cl-json" args."cl-ppcre" args."trivial-features" args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cffi/2021-04-11/cffi_0.24.1.tgz";
    sha256 = "1ir8a4rrnilj9f8rv1hh6fhkg2wp8z8zcf9hiijcix50pabxq8qh";
  };

  packageName = "cffi";

  asdFilesToKeep = ["cffi.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi DESCRIPTION The Common Foreign Function Interface SHA256
    1ir8a4rrnilj9f8rv1hh6fhkg2wp8z8zcf9hiijcix50pabxq8qh URL
    http://beta.quicklisp.org/archive/cffi/2021-04-11/cffi_0.24.1.tgz MD5
    c3df5c460e00e5af8b8bd2cd03a4b5cc NAME cffi FILENAME cffi DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-json FILENAME cl-json) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME trivial-features FILENAME trivial-features)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES (alexandria babel cl-json cl-ppcre trivial-features uiop)
    VERSION cffi_0.24.1 SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-toolchain
     cffi-uffi-compat)
    PARASITES (cffi/c2ffi cffi/c2ffi-generator)) */
