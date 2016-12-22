{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.1.2";
  branch = "2.1";
  revision = "v2.1.2";
  sha256 = "0kdcl9sqjz0vagli4ad6bxq1r8ma086m0prpkm5x3dxp37hpjp8h";

  patches = [
    # Fetched from https://github.com/szukw000/openjpeg/commit/cadff5fb6e73398de26a92e96d3d7cac893af255
    # Referenced from https://bugzilla.redhat.com/show_bug.cgi?id=1405135
    # Put in our source code to make sure we don't lose it, since that
    # referenced commit is someone else's fork, and not actually up-stream.
    ./CVE-2016-9580-and-CVE-2016-9581.patch
  ];
})
