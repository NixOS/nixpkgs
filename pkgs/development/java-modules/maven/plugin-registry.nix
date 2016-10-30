{ fetchMaven }:

rec {
  mavenPluginRegistry_2_0_9 = map (obj: fetchMaven {
    version = "2.0.9";
    baseName = "maven-plugin-registry";
    package = "/org/apache/maven";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "14mkwxvj0rbj28df9gjnkvr20paayqdmsg0vrzcb23d3xng3zc1fy5hvkifnp7xg73qxpdz0nij56lnnj7q2dqxcnmqvh0vslhc2xja"; }
    { type = "pom"; sha512 = "0c09imgd44b3pgnj1bjak7xn2z3mpwy9nhbchagfqkicras4djmn2dqwpm1z6p1d4khwx830x9grjrw45przan8lgc7wxzkalnnaqkf"; }
  ];
}
