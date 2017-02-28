{ fetchMaven }:

rec {
  findbugsJsr305_2_0_1 = map (obj: fetchMaven {
    version = "2.0.1";
    artifactId = "jsr305";
    groupId = "com.google.code.findbugs";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "33flq50603n496c90981a0gsv30pgk6cnf859vdj6c8n4iq973prq847z5q8ld64j3rdmakxy9rsp49w7pddfd0v0i9n97rkr435f5k"; }
    { type = "pom"; sha512 = "2iavm6d9nmy4g2i6y7q4l68bpjpncng1qfhbxdj44l3nqi7ixcjw0y38ymial7g2z0r1kd9qydr5lawjspr0fbzpjkcln2q7gsf0hfw"; }
  ];
}

