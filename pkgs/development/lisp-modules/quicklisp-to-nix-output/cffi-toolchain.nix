args @ { fetchurl, ... }:
rec {
  baseName = ''cffi-toolchain'';
  version = ''cffi_0.20.0'';

  description = ''The CFFI toolchain'';

  deps = [ args."alexandria" args."babel" args."cffi" args."trivial-features" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cffi/2018-12-10/cffi_0.20.0.tgz'';
    sha256 = ''1jal7r0dqp0sc5wj8a97xjlvfvayymdp1w3172hdxfppddnhhm8z'';
  };

  packageName = "cffi-toolchain";

  asdFilesToKeep = ["cffi-toolchain.asd"];
  overrides = x: x;
}
/* (SYSTEM cffi-toolchain DESCRIPTION The CFFI toolchain SHA256
    1jal7r0dqp0sc5wj8a97xjlvfvayymdp1w3172hdxfppddnhhm8z URL
    http://beta.quicklisp.org/archive/cffi/2018-12-10/cffi_0.20.0.tgz MD5
    94a8b377cf1ac7d8fc73dcc98f3420c6 NAME cffi-toolchain FILENAME
    cffi-toolchain DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME cffi FILENAME cffi)
     (NAME trivial-features FILENAME trivial-features))
    DEPENDENCIES (alexandria babel cffi trivial-features) VERSION cffi_0.20.0
    SIBLINGS
    (cffi-examples cffi-grovel cffi-libffi cffi-tests cffi-uffi-compat cffi)
    PARASITES NIL) */
