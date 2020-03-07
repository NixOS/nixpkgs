import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "241";
  sha256.i686-linux = "1niiwifby8zqvsh0ccdf3n21vlqfvvms223dc3kw2c2rksch3yg4";
  sha256.x86_64-linux = "1jz8d6663jspxgw8yxxx5ca6jaa3g67dbbi5d83pdxjmg1kk57a1";
  sha256.armv7l-linux = "1pjzyi1qd4nzfwvh0z5fpwga7j8mksiv5h8wzirv2ccdyy4wqw24";
  sha256.aarch64-linux = "1zliv4a0ygrsdpq36b89yl7jf7kidmxqbnp1sk2661y471x02p9l";
  jceName = "jce_policy-8.zip";
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
