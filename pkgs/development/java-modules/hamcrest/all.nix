{ fetchMaven }:

rec {
  hamcrestAll_1_3 = map (obj: fetchMaven {
    version = "1.3";
    artifactId = "hamcrest-all";
    groupId = "org.hamcrest";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "3pmh19hhwr2vcvj3wqx0m8gipilny4ap9gax1xpks4k5pwykh74w0x9iwpns7cl8r7kqd6rbq4khhc0shcmfh6gydr8ax201wc7lvb8"; }
    { type = "pom"; sha512 = "1w0byl3qy1gq2d8r66fzpffalc7pqm82iz5k3bqcxhclb60ifadmsxi1icqdhfpa29gvr5p1j5723zqpr11dk9w3p16njxc0arqxp2h"; }
  ];
}

