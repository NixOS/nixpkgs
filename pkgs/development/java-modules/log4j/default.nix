{ fetchMaven }:

rec {
  log4j_1_2_12 = map (obj: fetchMaven {
    version = "1.2.12";
    artifactId = "log4j";
    groupId = "log4j";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "jar"; sha512 = "23amz03i51w4vhh2wfq4fppi5qp2rzy0gqz4fdaqg4s3mz0aj86jylp7akj7aprnm28q2y1v4sj0s64qqvakj1vj020hr9y8rrifdga"; }
    { type = "pom"; sha512 = "0n5w0ywp90lllnyyxhaa7py1gapdw85jnnyyk86rm46k132q1lq6j7rh1mvzw1z01lh7bzb800r0rmgcc1mgn3fjgr9hxlr4ssm7gbx"; }
  ];
}

