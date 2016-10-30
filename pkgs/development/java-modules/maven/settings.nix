{ fetchMaven }:

rec {
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
}
