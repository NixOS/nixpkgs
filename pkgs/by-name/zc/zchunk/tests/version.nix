{ testers, zchunk }:

testers.testVersion {
  package = zchunk;
  command = "zck --version";
}
