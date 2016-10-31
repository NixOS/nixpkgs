{ fetchMaven }:

rec {
  mavenSettings_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "maven-settings";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3yvxlk0d40p1i0vwf4ba6k45kikcvip1vvr86k6cnhs86gfy6w1b4kw4hc6p23i978cgcl19g79m0l40nsxpav9hc07573k47ammclv"; }
    { type = "pom"; sha512 = "03cz2z90h9c3lssl53glbpz9hflsgb3a14i4xr5p7lpm993c07zn7xp2f6sjcdq7b774spbiww0alll9cz2vs8m7pvvwnbxk0s09d7l"; }
  ];

  mavenSettings_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-settings";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1hy1wz2bb7f9y0rr5961zhalpbwmk0fhw49k0l527w897lz4zw7lnb8xnx530s6hmn58zqj7iwkx4spz2fahps4ss1ryk0601rzgv4a"; }
    { type = "pom"; sha512 = "3i2nq3r6piwhv265jhsj9hqriw6113vkqllx5s4kd4y2dspjxh6l9xprrw347nkw68904dyq9hdx76fx2nzjd16ldh41pim5lw8r15n"; }
  ];

  mavenSettings_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    baseName = "maven-settings";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1hy1wz2bb7f9y0rr5961zhalpbwmk0fhw49k0l527w897lz4zw7lnb8xnx530s6hmn58zqj7iwkx4spz2fahps4ss1ryk0601rzgv4a"; }
    { type = "pom"; sha512 = "3i2nq3r6piwhv265jhsj9hqriw6113vkqllx5s4kd4y2dspjxh6l9xprrw347nkw68904dyq9hdx76fx2nzjd16ldh41pim5lw8r15n"; }
  ];
}
