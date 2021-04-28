/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-with-current-source-form";
  version = "20200427-git";

  description = "Helps macro writers produce better errors for macro users";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-with-current-source-form/2020-04-27/trivial-with-current-source-form-20200427-git.tgz";
    sha256 = "05zkj42f071zhg7swfyklg44k0zc893c9li9virkigzmvhids84f";
  };

  packageName = "trivial-with-current-source-form";

  asdFilesToKeep = ["trivial-with-current-source-form.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-with-current-source-form DESCRIPTION
    Helps macro writers produce better errors for macro users SHA256
    05zkj42f071zhg7swfyklg44k0zc893c9li9virkigzmvhids84f URL
    http://beta.quicklisp.org/archive/trivial-with-current-source-form/2020-04-27/trivial-with-current-source-form-20200427-git.tgz
    MD5 9a1367a5434664bd1ca2215d06e6d5cf NAME trivial-with-current-source-form
    FILENAME trivial-with-current-source-form DEPS
    ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION
    20200427-git SIBLINGS NIL PARASITES NIL) */
