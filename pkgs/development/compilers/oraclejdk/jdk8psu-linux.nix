import ./jdk-linux-base.nix {
  productVersion = "8";
  patchVersion = "192";
  downloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html;
  sha256.i686-linux = "1ki67svhh9i3qaqwq9yzvyzk5ipd7nbv2sl5l286vy9nk9kdgq8v";
  sha256.x86_64-linux = "1hi3ldv8pwh24pr3hr9mj3i9biqi2kg6gd0kp43lqmn5gwaawd3d";
  sha256.armv7l-linux = "0fz4f3dpgin9qp7556imry1x51p1c2vfwlbkv3j32mp1qpp2ppp8";
  sha256.aarch64-linux = "1q56399kfn04nplr1hahrj9zhsnrvzgz0161i7lgihxw8fr88g5n";
  jceName = "jce_policy-8.zip";
  jceDownloadUrl = http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html;
  sha256JCE = "0n8b6b8qmwb14lllk2lk1q1ahd3za9fnjigz5xn65mpg48whl0pk";
}
