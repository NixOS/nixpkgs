{ fetchMaven }:

rec {
  commonsLoggingApi_1_1 = map (obj: fetchMaven {
    version = "1.1";
    artifactId = "commons-logging-api";
    groupId = "commons-logging";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "3fp3d08l6m1xmma6pz7hvkvj5isbnyjimgvxf4plrwqmalifw0ywjbal5r5kmmrdlcda7l49mxdsv43ygglm9g22dzkbhdqlhlrn934"; }
    { type = "jar"; sha512 = "316dgnyhwai9n8dqjkp9chkkbhkyli9mfbgsj8ch6cdpmzmcvzirnjj7z1xbxm7v8hlybqhyaf5075pxwz3cg1w5ih3rhwjfi19f8dq"; }
  ];
}
