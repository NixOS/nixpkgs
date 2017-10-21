{ fetchMaven }:

rec {
  xmlApis_1_3_03 = map (obj: fetchMaven {
    version = "1.3.03";
    artifactId = "xml-apis";
    groupId = "xml-apis";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2sx6rm0lgzidcq1q81gnwxcj1himyny986ys6r60r3ws1p4bgxprargh5fdrmkp90djqzvy6d5b0sa0zfg1r9spynjbc8rjbr6agys9"; }
    { type = "pom"; sha512 = "2n2pjaclvgllb8nzqkibvp1pida7sr9kmz0ngmsdrpk7sh5wrh32ri82gdj5l9mc1z88dwjyn1ydz6aazw36gdqqdwj3ba1mqs6pqmh"; }
  ];
}
