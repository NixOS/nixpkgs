/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-with-current-source-form";
  version = "20210630-git";

  description = "Helps macro writers produce better errors for macro users";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-with-current-source-form/2021-06-30/trivial-with-current-source-form-20210630-git.tgz";
    sha256 = "0xa4mmrrkqr8lg74wk04ccgx06r17jskhrfmw23ywpbi2yy1qyhp";
  };

  packageName = "trivial-with-current-source-form";

  asdFilesToKeep = ["trivial-with-current-source-form.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-with-current-source-form DESCRIPTION
    Helps macro writers produce better errors for macro users SHA256
    0xa4mmrrkqr8lg74wk04ccgx06r17jskhrfmw23ywpbi2yy1qyhp URL
    http://beta.quicklisp.org/archive/trivial-with-current-source-form/2021-06-30/trivial-with-current-source-form-20210630-git.tgz
    MD5 0b4fe9e9a99e0729cc8ecf851df2a6c5 NAME trivial-with-current-source-form
    FILENAME trivial-with-current-source-form DEPS
    ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION
    20210630-git SIBLINGS NIL PARASITES NIL) */
