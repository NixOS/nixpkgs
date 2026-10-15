rec {
  version = "0.19.1";
  tag = version;
  hash = "sha256-wDMOFbwATIp0+wwlGxm5yEqnw7EtNc/savQy3RI2a/8=";
  cargoHash = "sha256-eKfqPipGrrKQZLVKyHPYyeGHl8xQEIm4X5I1lfEwdxA=";
  updateScript = ./update-unstable.sh;
  patches = [ ./0001-no-network-test.patch ];
}
