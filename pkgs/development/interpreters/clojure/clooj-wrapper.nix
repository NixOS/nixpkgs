{writeTextFile, jre, clooj}:

writeTextFile {
  name = "clooj-wrapper";
  executable = true;
  destination = "/bin/clooj";
  text = ''
    #!/bin/sh
    exec ${jre}/bin/java -jar ${clooj}/lib/java/clooj.jar
  '';
}
