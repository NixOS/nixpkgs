{writeTextFile, jre, clojure}:

writeTextFile {
  name = "clojure-wrapper";
  executable = true;
  destination = "/bin/clojure";
  text = ''
    #!/bin/sh
    exec ${jre}/bin/java -cp ${clojure}/lib/java/clojure.jar clojure.main
  '';
}