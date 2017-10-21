{ fetchMaven }:

rec {
  mavenSettings_2_0_1 = map (obj: fetchMaven {
    version = "2.0.1";
    artifactId = "maven-settings";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3jf3iix8zwbjrfxswn4x4q5jxmpkm5bqq0pb6yq5vjk74kipkk6cl5cfjhy8pakb1fymq7j7knsi791xp6jrhyyrzi31lgprdmlk06x"; }
    { type = "pom"; sha512 = "2r0256akp6gkcg7mjpaf27s985x2hblqk2dqcjq4cl415j4hx1xvarvvkh9py8sk8sjp66nzabph2kyk7v01cy29ryay6b6hn1wzi62"; }
  ];

  mavenSettings_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    artifactId = "maven-settings";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3yvxlk0d40p1i0vwf4ba6k45kikcvip1vvr86k6cnhs86gfy6w1b4kw4hc6p23i978cgcl19g79m0l40nsxpav9hc07573k47ammclv"; }
    { type = "pom"; sha512 = "03cz2z90h9c3lssl53glbpz9hflsgb3a14i4xr5p7lpm993c07zn7xp2f6sjcdq7b774spbiww0alll9cz2vs8m7pvvwnbxk0s09d7l"; }
  ];

  mavenSettings_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    artifactId = "maven-settings";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1hy1wz2bb7f9y0rr5961zhalpbwmk0fhw49k0l527w897lz4zw7lnb8xnx530s6hmn58zqj7iwkx4spz2fahps4ss1ryk0601rzgv4a"; }
    { type = "pom"; sha512 = "3i2nq3r6piwhv265jhsj9hqriw6113vkqllx5s4kd4y2dspjxh6l9xprrw347nkw68904dyq9hdx76fx2nzjd16ldh41pim5lw8r15n"; }
  ];

  mavenSettings_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    artifactId = "maven-settings";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3fn6wij56cx3knhyn2w5q4bvsl6sm2ad5wxgszpp4mw5jvl5smczz3k6gpg1bnj5m9f0r9w4aahnf64qxpv4v0lv8fd6k6arwzr1lxd"; }
    { type = "pom"; sha512 = "1vmbcxbrklhsyqhhz5x0skkckghi3lwgpksxi3aw0j57f86h7rk464ww1zppym451pqgqnpyvl83zzkizad5n8y8hrw41hgh1cdn3ij"; }
  ];
}
