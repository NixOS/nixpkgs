{ lib
, stdenv
, callPackage
, linuxHeaders ? null
, withLinuxHeaders ? true
, profilingLibraries ? false
, withGd ? false
, withLibcrypt? false
}:

(callPackage ./common.nix {
  inherit stdenv;
} {
  inherit withLinuxHeaders withGd profilingLibraries withLibcrypt;
  pname = "glibc-headers";
}).overrideAttrs(previousAttrs: {

  configureFlags = previousAttrs.configureFlags ++ [
    # From https://sourceware.org/legacy-ml/libc-alpha/2003-11/msg00044.html
    "--enable-hacker-mode"
    "--disable-sanity-checks"
  ];

  dontBuild = true;
  makeFlags = [  ];

  installFlags = previousAttrs.installFlags ++ [
    "cross-compiling=yes"
  ];
  installTargets = [
    "install-headers"
  ];

  # deliberately clobber `moveToOutput getent`
  postInstall = ''
    cp ../$sourceRoot/include/gnu/stubs.h $dev/include/gnu/stubs.h
    (cd $dev/include && ln -sv $(ls -d ${lib.getDev linuxHeaders}/include/* | grep -v scsi\$) .)
  '';

  outputs = [ "dev" "out" ];

  meta = (previousAttrs.meta or {}) // {
    description = "The GNU C Library, target platform headers only";
    longDescription = ''
      This package contains the glibc headers, built without using a
      target-platform compiler.  It breaks the circular dependency
      between the target platform compiler and glibc's headers.
    '';
  };
})
