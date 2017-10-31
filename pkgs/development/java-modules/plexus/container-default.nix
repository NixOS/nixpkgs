{ fetchMaven }:

rec {
  plexusContainerDefault_1_0_alpha9 = map (obj: fetchMaven {
    version = "1.0-alpha-9";
    artifactId = "plexus-container-default";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "2niq80yyq5kaq4qbmqsbibz9i1b6xqrfwy6iabddx9lwacsrq3a1qwh1ih877vk6dcgq8gbi0ahx19x95vwvbpp7449ja4wml5xmag2"; }
    { type = "pom"; sha512 = "144xr23kq2ljhzzvac6w2s120s96jfaccaishb9lqmrx0a8gkq949ccyf3qmv6srryflsqc0sksl7rr3294iwjgwj04xidhd8c5jycd"; }
  ];

  plexusContainerDefault_1_0_alpha9_stable1 = map (obj: fetchMaven {
    version = "1.0-alpha-9-stable-1";
    artifactId = "plexus-container-default";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "1dpzdijx7xb3kgv2ybias3shzvpsq82w6x1ig5gdkg0i47m6a1ld53bi3gjczdpn88xparp80jkqlacjb65764v05ps6zg0v3vr1dkw"; }
    { type = "pom"; sha512 = "1gnm9ivwrkr3aqpnmdl34hkx53189wxj9acp2fms8inhznrxqcyyk355gpgzwvs9qpgdis1q88mj1fy3x1v3ffa3b6wi758p95q79jc"; }
  ];

  plexusContainerDefault_1_5_5 = map (obj: fetchMaven {
    version = "1.5.5";
    artifactId = "plexus-container-default";
    groupId = "org.codehaus.plexus";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3f6qyisir3k7aa627fqh0q98zvfc4hz8xq1rzjgqjhgv34m2x8kgwfxvlcik5v7724gjj41vjvs909xw7l0v80ryhvl95r35ndqzvzy"; }
    { type = "pom"; sha512 = "2axphhx8xiii80gbf9gmm6qrm6m4ws4fbdcmghzfsn1yvmmjsj7x1c15g5mkq0lhh0skscibqifsxh44qix21qfkxr532681jh5qq5h"; }
  ];
}
