{ callPackage, fetchpatch, ... } @ args:

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

    (fetchpatch {
      url = "https://bugzilla.suse.com/attachment.cgi?id=707359&action=diff&context=patch&collapsed=&headers=1&format=raw";
      name = "CVE-2016-9112.patch";
      sha256 = "18hqx73wdzfybr5n5k6pzhbhdlmawiqbjci8n82zykxiyfgp18pd";
    })
    (fetchpatch {
      url = "https://bugzilla.suse.com/attachment.cgi?id=707354&action=diff&context=patch&collapsed=&headers=1&format=raw";
      name = "CVE-2016-9114.patch";
      sha256 = "0qam3arw9kdbh4501xim2pyldl708dnpyjwvjmwc9gc7hcq4gfi3";
    })
    (fetchpatch {
      url = "https://bugzilla.suse.com/attachment.cgi?id=707356&action=diff&context=patch&collapsed=&headers=1&format=raw";
      name = "CVE-2016-9116.patch";
      sha256 = "0yyb3pxqi5sr44a48bacngzp206j4z49lzkg6hbkz1nra9na61a3";
    })
    (fetchpatch {
      url = "https://bugzilla.suse.com/attachment.cgi?id=707358&action=diff&context=patch&collapsed=&headers=1&format=raw";
      name = "CVE-2016-9118.patch";
      sha256 = "125n8bmh07y7697s0y82ypb39rxgj0bdn8rcywbvamscagwg2wy9";
    })
  ];
})
