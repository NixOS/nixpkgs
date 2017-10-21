{ fetchMaven }:

rec {
  mavenPluginParameterDocumenter_2_0_1 = map (obj: fetchMaven {
    version = "2.0.1";
    artifactId = "maven-plugin-parameter-documenter";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3hx5wg0jqhhknfgb98j7d3xy452lyw5yr3ncbk0jfzx1xkxc3v101s5s192q3c2agjgj76xsk1axmipdmwfv3801rbk99hmyjhdqbkn"; }
    { type = "pom"; sha512 = "0x56m654vdgakslrbzfnvarh699ag288drbk6vnwjp5xxa5jg9vizrm6kz1917d2qygrpqnn5b6yzwawj864qy9xdadzr9mbak33424"; }
  ];

  mavenPluginParameterDocumenter_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    artifactId = "maven-plugin-parameter-documenter";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "11yxhw6pn6np1a828ww6iq4gcg6i6l6wlr6pwx3kd0fh4cavd93rfh2khvydfsz0cw40m1kbqglnwdqbdc9d5akhwpnvhkfwsqvl8li"; }
    { type = "pom"; sha512 = "0g62n2g7jcknzgnpl46fsdn9yndjv09fwijahlnmc1gh9w2v0rxyq42p133vgv13jc5wzfqyrf7mh3fq7p0w9mfbharaz92flh2caik"; }
  ];

  mavenPluginParameterDocumenter_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    artifactId = "maven-plugin-parameter-documenter";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "0djr58wp7a93p96sn0k24d6liabd7a4qvsd0p7lk88ws3jwfw5bqh6d0a3fyc86fkask1wi7krrvsm7i6yiw1f1r0d6xjzj8fx5m4kz"; }
    { type = "pom"; sha512 = "39mhwcxwcqgy6pk3qlabs1b8k8fqvkps6r1zb1n7phfwh4dklngyqdrxh90j3wjg3692l7as1k0439z2x124wlh6bzpv83jmx64jiyh"; }
  ];

  mavenPluginParameterDocumenter_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    artifactId = "maven-plugin-parameter-documenter";
    groupId = "org.apache.maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3fp8c3mz9w83r497mx8lrb3lb65v9m2hrqjs2kq7hdzg99rcgwcflg3dcv5bg89xf8vhr853zm702l3s40dqq41ys69g4f1h0ksdkld"; }
    { type = "pom"; sha512 = "392c3zmdvwbz7iakaf93bk82s4la0wr8dj88vz2ipsbakmvqk82hs4r6jkpx7mkl04qhrpk4n4d7gl1gllhkyqapvdddf5qvp6a6b5q"; }
  ];
}
