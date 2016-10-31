{ fetchMaven }:

rec {
  sisuGuice_2_9_4 = map (obj: fetchMaven {
    version = "2.9.4";
    baseName = "sisu-guice";
    package = "/org/sonatype/sisu";
    suffix = "-no_aop";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1529vg4r0gy3ss68lprkdf13r79r0lng4iyx68gj94cf806li9kayi9p2byl6axbx174cvam9w3l90qcdsdz14vrvm163b2r8sq927m"; }
  ];
}
