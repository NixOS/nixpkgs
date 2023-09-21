/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cffi-toolchain";
  version = "cffi_0.24.1";

  description = "The CFFI toolchain";

  deps = [ args."alexandria" args."asdf" args."babel" args."cffi" args."trivial-features" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cffi/2021-04-11/cffi_0.24.1.tgz";
    sha256 = "1ir8a4rrnilj9f8rv1hh6fhkg2wp8z8zcf9hiijcix50pabxq8qh";
  };

  packageName = "cffi-toolchain";

  asdFilesToKeep = ["cffi-toolchain.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi-toolchain DESCRIPTION The CFFI toolchain SHA256
    1ir8a4rrnilj9f8rv1hh6fhkg2wp8z8zcf9hiijcix50pabxq8qh URL
    http://beta.quicklisp.org/archive/cffi/2021-04-11/cffi_0.24.1.tgz MD5
    c3df5c460e00e5af8b8bd2cd03a4b5cc NAME cffi-toolchain FILENAME
    cffi-toolchain DEPS
    ((NAME alexandria FILENAME alexandria) (NAME asdf FILENAME asdf)
     (NAME babel FILENAME babel) (NAME cffi FILENAME cffi)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria asdf babel cffi trivial-features) VERSION
    cffi_0.24.1 SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-uffi-compat cffi)
    PARASITES NIL) */
