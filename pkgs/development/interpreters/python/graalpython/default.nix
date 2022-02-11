{ pkgs
, lib
, graalvm8
, passthruFun
, packageOverrides ? (self: super: {})
, self
}:

let
  passthru = passthruFun {
    inherit self packageOverrides;
    implementation = "graal";
    sourceVersion = graalvm8.version;
    pythonVersion = "3.7";
    libPrefix = "graalvm";
    sitePackages = "jre/languages/python/lib-python/3/site-packages";
    executable = "graalpython";
    hasDistutilsCxxPatch = false;
    pythonForBuild = pkgs.buildPackages.pythonInterpreters.graalpython37;
  };
in lib.extendDerivation true passthru graalvm8
