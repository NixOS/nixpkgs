args @ { fetchurl, ... }:
rec {
  baseName = ''cffi'';
  version = ''cffi_0.19.0'';

  parasites = [ "cffi/c2ffi" "cffi/c2ffi-generator" ];

  description = ''The Common Foreign Function Interface'';

  deps = [ args."alexandria" args."babel" args."cl-json" args."cl-ppcre" args."trivial-features" args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2018-02-28/cffi_0.19.0.tgz'';
    sha256 = ''12v3ha0qp3f9lq2h3d7y3mwdq216nsdfig0s3c4akw90rsbnydj9'';
  };

  packageName = "cffi";

  asdFilesToKeep = ["cffi.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi DESCRIPTION The Common Foreign Function Interface SHA256
    12v3ha0qp3f9lq2h3d7y3mwdq216nsdfig0s3c4akw90rsbnydj9 URL
    http://beta.quicklisp.org/archive/cffi/2018-02-28/cffi_0.19.0.tgz MD5
    7589b6437fec19fdabc65892536c3dc3 NAME cffi FILENAME cffi DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cl-json FILENAME cl-json) (NAME cl-ppcre FILENAME cl-ppcre)
     (NAME trivial-features FILENAME trivial-features)
     (NAME uiop FILENAME uiop))
    DEPENDENCIES (alexandria babel cl-json cl-ppcre trivial-features uiop)
    VERSION cffi_0.19.0 SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-toolchain
     cffi-uffi-compat)
    PARASITES (cffi/c2ffi cffi/c2ffi-generator)) */
