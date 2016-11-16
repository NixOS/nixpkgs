{ fetchMaven }:

rec {
  xbeanReflect_3_4 = map (obj: fetchMaven {
    version = "3.4";
    artifactId = "xbean-reflect";
    groupId = "org.apache.xbean";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "1nny6dcwif0kd0kr2l55j2l5rb1aw8l2f2fbhanj6j48zhcz3vv1wx5xi0l6vg4j70y12fxyg1kyn4lq0bx19by19r73k06wlxs001k"; }
    { type = "jar"; sha512 = "3w22jbm4sii16lzkzwi6hv5zbid5jw8dv356q9hr0pnb8d4gm6ypl2pjqj0brzmpq9pydqya14wk798ddjalqjh25rl2ry9qhjx3hlm"; }
  ];
}
