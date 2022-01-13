/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "cl-mustache";
  version = "20200325-git";

  description = "Mustache Template Renderer";

  deps = [ args."uiop" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/cl-mustache/2020-03-25/cl-mustache-20200325-git.tgz";
    sha256 = "1x1rsmgqc39imx4ay3b35dzvzccaqjayz90qv2cylqbbq9sg9arr";
  };

  packageName = "cl-mustache";

  asdFilesToKeep = ["cl-mustache.asd"];
  overrides = x: x;
}
/* (SYSTEM cl-mustache DESCRIPTION Mustache Template Renderer SHA256
    1x1rsmgqc39imx4ay3b35dzvzccaqjayz90qv2cylqbbq9sg9arr URL
    http://beta.quicklisp.org/archive/cl-mustache/2020-03-25/cl-mustache-20200325-git.tgz
    MD5 52381d17458d88d6a8b760f351bf517d NAME cl-mustache FILENAME cl-mustache
    DEPS ((NAME uiop FILENAME uiop)) DEPENDENCIES (uiop) VERSION 20200325-git
    SIBLINGS (cl-mustache-test) PARASITES NIL) */
