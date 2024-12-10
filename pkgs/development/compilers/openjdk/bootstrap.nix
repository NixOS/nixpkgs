{
  stdenv,
  runCommand,
  fetchurl,
  zlib,

  version,
}:

assert stdenv.hostPlatform.libc == "glibc";

let
  fetchboot =
    version: arch: sha256:
    fetchurl {
      name = "openjdk${version}-bootstrap-${arch}-linux.tar.xz";
      url = "http://tarballs.nixos.org/openjdk/2018-03-31/${version}/${arch}-linux.tar.xz";
      inherit sha256;
    };

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      (
        if version == "10" then
          fetchboot "10" "x86_64" "08085fsxc1qhqiv3yi38w8lrg3vm7s0m2yvnwr1c92v019806yq2"
        else if version == "8" then
          fetchboot "8" "x86_64" "18zqx6jhm3lizn9hh6ryyqc9dz3i96pwaz8f6nxfllk70qi5gvks"
        else
          throw "No bootstrap jdk for version ${version}"
      )
    else if stdenv.hostPlatform.system == "i686-linux" then
      (
        if version == "10" then
          fetchboot "10" "i686" "1blb9gyzp8gfyggxvggqgpcgfcyi00ndnnskipwgdm031qva94p7"
        else if version == "8" then
          fetchboot "8" "i686" "1yx04xh8bqz7amg12d13rw5vwa008rav59mxjw1b9s6ynkvfgqq9"
        else
          throw "No bootstrap for version"
      )
    else
      throw "No bootstrap jdk for system ${stdenv.hostPlatform.system}";

  bootstrap =
    runCommand "openjdk-bootstrap"
      {
        passthru.home = "${bootstrap}/lib/openjdk";
      }
      ''
        tar xvf ${src}
        mv openjdk-bootstrap $out

        LIBDIRS="$(find $out -name \*.so\* -exec dirname {} \; | sort | uniq | tr '\n' ':')"

        find "$out" -type f -print0 | while IFS= read -r -d "" elf; do
          isELF "$elf" || continue
          patchelf --set-interpreter $(cat "${stdenv.cc}/nix-support/dynamic-linker") "$elf" || true
          patchelf --set-rpath "${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib:${zlib}/lib:$LIBDIRS" "$elf" || true
        done
      '';
in
bootstrap
