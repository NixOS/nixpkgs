{ callPackage }:
callPackage ./binary.nix {
  version = "1.17.13";
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    darwin-amd64 = "c101beaa232e0f448fab692dc036cd6b4677091ff89c4889cc8754b1b29c6608";
    darwin-arm64 = "e4ccc9c082d91eaa0b866078b591fc97d24b91495f12deb3dd2d8eda4e55a6ea";
    linux-386 = "5e02f35aecc6b89679f631e0edf12c49922dd31c8140cf8dd725c5797a9f2425";
    linux-amd64 = "4cdd2bc664724dc7db94ad51b503512c5ae7220951cac568120f64f8e94399fc";
    linux-arm64 = "914daad3f011cc2014dea799bb7490442677e4ad6de0b2ac3ded6cee7e3f493d";
    linux-armv6l = "260431d7deeb8893c21e71fcbbb1fde3258616d8eba584c8d72060228ab42c86";
    linux-ppc64le = "bd0763fb130f8412672ffe1e4a8e65888ebe2419e5caa9a67ac21e8c298aa254";
    linux-s390x = "08f6074e1e106cbe5d78622357db71a93648c7a4c4e4b02e3b5f2a1828914c76";
  };
}
