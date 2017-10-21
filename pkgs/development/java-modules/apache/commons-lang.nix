{ fetchMaven }:

rec {
  commonsLang_2_1 = map (obj: fetchMaven {
    version = "2.1";
    artifactId = "commons-lang";
    groupId = "commons-lang";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1hr3q67cn0nk5kn9vdfs8155cw814jf20jk7dsn3cn0a6l2j6dx297z6akz5f62dkkn0nj4pac7z4wvnawisnvzhpg6q6qhwj7wwc8n"; }
    { type = "jar"; sha512 = "2phbi7q2k3v48gyys7s0yw8xaa9kpczwif5jfqgfarzf7il1r0vplpwgwcnlsxpifjjnap7lw0yq38zp0mbajp7h8p5z0qp7gisa4m3"; }
  ];

  commonsLang_2_3 = map (obj: fetchMaven {
    version = "2.3";
    artifactId = "commons-lang";
    groupId = "commons-lang";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "0i94xb3fgq0ig0aids9r1h1kblhlf762gsjxh422ra23saa4474q4iywgfk596bpcflngf2sarq8ch6lw09p0g43779d23b74bd939n"; }
    { type = "jar"; sha512 = "1f30pryvd39m2yazflzy5l1h4l473dj8ccrd9v8z8lb6iassn4xc142f2snkzxlc7ncqsi6fbfd3zfxsy8afivmxmxds6mbsrxayqwk"; }
  ];

  commonsLang_2_6 = map (obj: fetchMaven {
    version = "2.6";
    artifactId = "commons-lang";
    groupId = "commons-lang";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "2b3yp5bawbh9b0gh56g35x03swrjv2c5jpvwjwric7ywadaf4p6cw1kmabldmi0y3rja5cypz7gfdm1pwdrpr9lmi48ijjssimmgsh1"; }
    { type = "jar"; sha512 = "11gnsj6c1rz61j19wnr0j5rbdnl63hq9axwm7wwampmdq70n3m1szbn014phl8y3nccvrq2ifcgwb48q6jwqs50rki4bij196z3snja"; }
  ];
}
