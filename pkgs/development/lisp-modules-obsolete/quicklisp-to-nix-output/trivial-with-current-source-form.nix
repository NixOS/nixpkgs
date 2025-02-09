/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "trivial-with-current-source-form";
  version = "20211020-git";

  description = "Helps macro writers produce better errors for macro users";

  deps = [ args."alexandria" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/trivial-with-current-source-form/2021-10-20/trivial-with-current-source-form-20211020-git.tgz";
    sha256 = "03x8yx5hqfydxbdy9nxpaqn6yfjv7hvw8idscx66ns4qcpw6p825";
  };

  packageName = "trivial-with-current-source-form";

  asdFilesToKeep = ["trivial-with-current-source-form.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-with-current-source-form DESCRIPTION
    Helps macro writers produce better errors for macro users SHA256
    03x8yx5hqfydxbdy9nxpaqn6yfjv7hvw8idscx66ns4qcpw6p825 URL
    http://beta.quicklisp.org/archive/trivial-with-current-source-form/2021-10-20/trivial-with-current-source-form-20211020-git.tgz
    MD5 b4a3721cbef6101de1c43c540b446efc NAME trivial-with-current-source-form
    FILENAME trivial-with-current-source-form DEPS
    ((NAME alexandria FILENAME alexandria)) DEPENDENCIES (alexandria) VERSION
    20211020-git SIBLINGS NIL PARASITES NIL) */
