rec {
  version = "0.19.0-rc.1";
  tag = version;
  hash = "sha256-xN154QH0CxPaoAN8oa5jj3G/wBRQgdBmYYnv0qMjShs=";
  cargoHash = "sha256-lC3hm6cdd7IyjjsGvXX39JAqVfA6SEkV0kEnXL83sC4=";
  updateScript = ./update-unstable.sh;
  patches = [ ./0001-no-network-test.patch ];
}
