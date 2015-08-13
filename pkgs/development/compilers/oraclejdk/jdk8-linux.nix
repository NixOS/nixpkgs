import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "51";
  url_i686 = http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-i586.tar.gz;
  url_x86_64 = http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.tar.gz;
  sha256_i686 = "0awzgs090n2cj6a5mlla0pgxk0y6aslhm6024pqrnxgai1fkmm1z";
  sha256_x86_64 = "1wggrcr2gjwkv5bawgcw86h6rhyzw0jphxm1sfwcvhjirh99056p";
  urlJCE = http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
