{ stdenv, jasmin, jre }:

stdenv.mkDerivation {
  name = "jasmin-test-assemble-hello-world";
  meta.timeout = 60;
  buildCommand = ''
    ${jasmin}/bin/jasmin ${./HelloWorld.j}
    ${lib.getExe jre} HelloWorld | grep "Hello World"
    touch $out
  '';
}

