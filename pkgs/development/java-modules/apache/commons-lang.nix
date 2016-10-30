{ fetchMaven }:

rec {
  commonsLang_2_3 = map (obj: fetchMaven {
    version = "2.3";
    baseName = "commons-lang";
    package = "/commons-lang";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "0i94xb3fgq0ig0aids9r1h1kblhlf762gsjxh422ra23saa4474q4iywgfk596bpcflngf2sarq8ch6lw09p0g43779d23b74bd939n"; }
    { type = "jar"; sha512 = "1f30pryvd39m2yazflzy5l1h4l473dj8ccrd9v8z8lb6iassn4xc142f2snkzxlc7ncqsi6fbfd3zfxsy8afivmxmxds6mbsrxayqwk"; }
  ];
}
