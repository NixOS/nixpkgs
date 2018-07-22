import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "181";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256.i686-linux = "0159q5wrlp24v8rc6m1cr3kq8nddpdjdprj3vsmf8z7vpwx052np";
  sha256.x86_64-linux = "1lwiz44vlxn4hc5b43r9arad15lpjfbr7l6h5vafpgxzjmq5ci8q";
  sha256.armv7l-linux = "0zpgb1hqf9zazic66c7nim036ac6ld3dhnsanx4ijlrl7kd3fbn7";
  sha256.aarch64-linux = "191r926501cm6mz8p93ljdfxi0dgzw7ljjsrzsbmmxn4k0q2j0ad";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
