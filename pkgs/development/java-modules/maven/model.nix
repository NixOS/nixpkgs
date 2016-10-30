{ fetchMaven }:

rec {
  mavenModel_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-model";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "14pxgdcim20x9lisf510nazzlcjxv9fpqabkdn0d86qa7d9270m4fmya5crasx2np9h0gxl407d77vcjf99fdxizg7i32w35yljqp3z"; }
    { type = "pom"; sha512 = "2vvyawhfq0gwa54ir5l2drcfxphkd47ghwgz89v3vsqgjry714vp01pa5a6yjlwfd45mknyrb71ws6dki4zjgzhdm09ck7cxg5qkpr9"; }
  ];

  mavenModel_3_0_3 = map (obj: fetchMaven {
    version = "3.0.3";
    baseName = "maven-model";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "13b339n0iibvy9x1d34b6gsnlz2s26ap866nhm4wyrlb0hkyb4zf7xbvc8aigr9zzzc4msn3yi98ylgsbinxx8dkbs89x1amnd7v1nr"; }
    { type = "pom"; sha512 = "38dbv2z16h1wq16pxx5nrpndpkmnmj6wxsa4x13hsm7skmfwxdr51ddjddc4qlqk9dfnny0yv3lf009k0pfs06hfn0xiv85ki5y1hfg"; }
  ];
}
