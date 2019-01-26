args @ { fetchurl, ... }:
rec {
  baseName = ''cffi-toolchain'';
  version = ''cffi_0.19.0'';

  description = ''The CFFI toolchain'';

  deps = [ args."alexandria" args."babel" args."cffi" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2018-02-28/cffi_0.19.0.tgz'';
    sha256 = ''12v3ha0qp3f9lq2h3d7y3mwdq216nsdfig0s3c4akw90rsbnydj9'';
  };

  packageName = "cffi-toolchain";

  asdFilesToKeep = ["cffi-toolchain.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi-toolchain DESCRIPTION The CFFI toolchain SHA256
    12v3ha0qp3f9lq2h3d7y3mwdq216nsdfig0s3c4akw90rsbnydj9 URL
    http://beta.quicklisp.org/archive/cffi/2018-02-28/cffi_0.19.0.tgz MD5
    7589b6437fec19fdabc65892536c3dc3 NAME cffi-toolchain FILENAME
    cffi-toolchain DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi trivial-features) VERSION cffi_0.19.0
    SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-uffi-compat cffi)
    PARASITES NIL) */
