{ fetchMaven }:

rec {
  mavenPluginApi_2_0_6 = map (obj: fetchMaven {
    version = "2.0.6";
    baseName = "maven-plugin-api";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "3926imf3d59530ldz9hajjq6xkb5mb1llx7br0025p8c1xfhgr4hqm6dripi0yd9f53sbdxhla5ly68q2vsbzbklpldrvrbz6b5wrql"; }
    { type = "jar"; sha512 = "34fb0yw3z7bxlxxs8wmv59g351jkfp16ljq5zmyksq54kz2wvkv39w7bcnvlkbdwaggm7cd2jr9s4y4lynkblp8ydf9jbq8awwr7c00"; }
  ];

  mavenPluginApi_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-plugin-api";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "23qj23k049jz4mp77h2wj4mnjqszb99l4xvxas93cpnbdl51a5s0d0rsg60a8zg0ic04n6fr8nig0vvmmcsggx93a96w4p3na97q30n"; }
    { type = "jar"; sha512 = "0hvl32k09wr34b6v0wl27y6353mx3afsgwyfw0vpx5aa5b8wiw86vlbknh3kjl43zp2ffxq6b4c7n07jq3y2wczz08gscs5apszhj9q"; }
  ];

  mavenPluginApi_2_2_1 = map (obj: fetchMaven {
    version = "2.2.1";
    baseName = "maven-plugin-api";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "23qj23k049jz4mp77h2wj4mnjqszb99l4xvxas93cpnbdl51a5s0d0rsg60a8zg0ic04n6fr8nig0vvmmcsggx93a96w4p3na97q30n"; }
    { type = "jar"; sha512 = "0hvl32k09wr34b6v0wl27y6353mx3afsgwyfw0vpx5aa5b8wiw86vlbknh3kjl43zp2ffxq6b4c7n07jq3y2wczz08gscs5apszhj9q"; }
  ];

  mavenPluginApi_3_0_3 = map (obj: fetchMaven {
    version = "3.0.3";
    baseName = "maven-plugin-api";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "17zyw3j4zbg1hhj18i4q1f0r8gdxl3q9x5ksyqlyr0mrw2sadc6lvbbhyp3l7vsbddl4bgdx36gwvjp5d97gbmk1nbpi1vabadfhq76"; }
    { type = "jar"; sha512 = "0rk2nzkwcrkfy3vs0zl0l2lxp3w4hkwxrypisbivv5al7sc8lbzls6jgpp3h5gx9kk4scjj24qf5vyimnbadj63rvqffg581fs2zgl9"; }
  ];
}
