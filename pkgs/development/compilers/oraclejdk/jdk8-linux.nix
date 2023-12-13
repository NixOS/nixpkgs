import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "281";
  sha256.i686-linux = "/yEY5O6MYNyjS5YSGZtgydb8th6jHQLNvI9tNPIh3+0=";
  sha256.x86_64-linux = "hejH2nJIx0UPsQVWeniEHQlzWXhQd2wkpSf+sC7z5YY=";
  sha256.armv7l-linux = "oXbW8hZxesDqwV79ANB4SdnS71O51ZApKbQhqq4i/EM=";
  sha256.aarch64-linux = "oFH3TeIzVsFk6IZcDEHVDVJC7dSbGcwhdUH/WUXSNDM=";
  jceName = "jce_policy-8.zip";
  sha256JCE = "19n5wadargg3v8x76r7ayag6p2xz1bwhrgdzjs9f4i6fvxz9jr4w";
}
