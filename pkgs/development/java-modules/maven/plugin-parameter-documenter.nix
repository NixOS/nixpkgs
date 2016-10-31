{ fetchMaven }:

rec {
  mavenPluginParameterDocumenter_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "maven-plugin-parameter-documenter";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "11yxhw6pn6np1a828ww6iq4gcg6i6l6wlr6pwx3kd0fh4cavd93rfh2khvydfsz0cw40m1kbqglnwdqbdc9d5akhwpnvhkfwsqvl8li"; }
    { type = "pom"; sha512 = "0g62n2g7jcknzgnpl46fsdn9yndjv09fwijahlnmc1gh9w2v0rxyq42p133vgv13jc5wzfqyrf7mh3fq7p0w9mfbharaz92flh2caik"; }
  ];

  mavenPluginParameterDocumenter_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-plugin-parameter-documenter";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0djr58wp7a93p96sn0k24d6liabd7a4qvsd0p7lk88ws3jwfw5bqh6d0a3fyc86fkask1wi7krrvsm7i6yiw1f1r0d6xjzj8fx5m4kz"; }
    { type = "pom"; sha512 = "39mhwcxwcqgy6pk3qlabs1b8k8fqvkps6r1zb1n7phfwh4dklngyqdrxh90j3wjg3692l7as1k0439z2x124wlh6bzpv83jmx64jiyh"; }
  ];

  mavenPluginParameterDocumenter_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    baseName = "maven-plugin-parameter-documenter";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0djr58wp7a93p96sn0k24d6liabd7a4qvsd0p7lk88ws3jwfw5bqh6d0a3fyc86fkask1wi7krrvsm7i6yiw1f1r0d6xjzj8fx5m4kz"; }
    { type = "pom"; sha512 = "39mhwcxwcqgy6pk3qlabs1b8k8fqvkps6r1zb1n7phfwh4dklngyqdrxh90j3wjg3692l7as1k0439z2x124wlh6bzpv83jmx64jiyh"; }
  ];
}
