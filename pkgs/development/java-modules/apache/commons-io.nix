{ fetchMaven }:

rec {
  commonsIo_2_1 = map (obj: fetchMaven {
    version = "2.1";
    artifactId = "commons-io";
    groupId = "commons-io";
    sha512 = obj.sha512;
    type = obj.type;
  }) [
    { type = "pom"; sha512 = "30bzhsnn2vhi3wfmkas58spl6sxvl9rvwkzaqf9z1lr3iz4iym6x1xgspgq1dvy7pwr7ajny1dfpj1l6vzh7adqm2b4pidjf2w00fp2"; }
    { type = "jar"; sha512 = "14b2kcjsn12cnrl1qc7v7r48m9vmpw5h9jljhsx58ac8xrlb8g6l71j9lnhp8cf8vc3jwz4drrwn4l9p3r5sk02cparl3h2r0y4cp2c"; }
  ];
}
