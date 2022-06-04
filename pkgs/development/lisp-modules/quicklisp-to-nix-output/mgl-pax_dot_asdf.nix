/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "mgl-pax_dot_asdf";
  version = "mgl-pax-20220220-git";

  description = "System lacks description";

  deps = [ ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/mgl-pax/2022-02-20/mgl-pax-20220220-git.tgz";
    sha256 = "0wfdj8np8fflp51zqsby0fwhad675xk0nbw02w0xxp4sjya0hk5a";
  };

  packageName = "mgl-pax.asdf";

  asdFilesToKeep = ["mgl-pax.asdf.asd"];
  overrides = x: x;
}
/* (SYSTEM mgl-pax.asdf DESCRIPTION System lacks description SHA256
    0wfdj8np8fflp51zqsby0fwhad675xk0nbw02w0xxp4sjya0hk5a URL
    http://beta.quicklisp.org/archive/mgl-pax/2022-02-20/mgl-pax-20220220-git.tgz
    MD5 51050b8c146333bd352e77d9ffee5475 NAME mgl-pax.asdf FILENAME
    mgl-pax_dot_asdf DEPS NIL DEPENDENCIES NIL VERSION mgl-pax-20220220-git
    SIBLINGS (mgl-pax) PARASITES NIL) */
