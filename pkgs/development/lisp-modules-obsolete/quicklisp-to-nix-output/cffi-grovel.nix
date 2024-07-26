/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cffi-grovel";
  version = "cffi_0.24.1";

  description = "The CFFI Groveller";

  deps = [ args."alexandria" args."babel" args."cffi" args."cffi-toolchain" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cffi/2021-04-11/cffi_0.24.1.tgz";
    sha256 = "1ir8a4rrnilj9f8rv1hh6fhkg2wp8z8zcf9hiijcix50pabxq8qh";
  };

  packageName = "cffi-grovel";

  asdFilesToKeep = ["cffi-grovel.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi-grovel DESCRIPTION The CFFI Groveller SHA256
    1ir8a4rrnilj9f8rv1hh6fhkg2wp8z8zcf9hiijcix50pabxq8qh URL
    http://beta.quicklisp.org/archive/cffi/2021-04-11/cffi_0.24.1.tgz MD5
    c3df5c460e00e5af8b8bd2cd03a4b5cc NAME cffi-grovel FILENAME cffi-grovel DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi) (NAME cffi-toolchain FILENAME cffi-toolchain)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi cffi-toolchain trivial-features)
    VERSION cffi_0.24.1 SIBLINGS
    (cffi-examples cffi-libffi cffi-tests cffi-toolchain cffi-uffi-compat cffi)
    PARASITES NIL) */
