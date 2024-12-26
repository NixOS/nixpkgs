{ callPackage }:
callPackage ./binary.nix {
  version = "1.22.10";
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    darwin-amd64 = "dd2c4ac3702658c2c20e3a8b394da1917d86156b2cb4312c9d2f657f80067874";
    darwin-arm64 = "21cf49415ffe0755b45f2b63e75d136528a32f7bb7bdd0166f51d22a03eb0a3f";
    freebsd-386 = "f82f5d194114963693e0f51fd56d55d8417ca556438062f2b0df608473b62837";
    freebsd-amd64 = "cce9da240870a4430c5cf1227bcf29d37575043ff16f7982a69f1139c6f564b5";
    freebsd-arm64 = "abae388d0d42563a242db0d405172cb73e09236f68000ff90c2a327ec8c5764c";
    freebsd-armv6l = "7c9c8fe30cbabbb4fb597f0f0ad1279fd2b320bc70831eba4c207b55ad46931d";
    freebsd-riscv64 = "d6f25fd79e17b84d1b61bec3e2fdffc47377b28b51a04b6bdbeac0199313e059";
    linux-386 = "2ae9f00e9621489b75494fa2b8abfc5d09e0cae6effdd4c13867957ad2e4deba";
    linux-amd64 = "736ce492a19d756a92719a6121226087ccd91b652ed5caec40ad6dbfb2252092";
    linux-arm64 = "5213c5e32fde3bd7da65516467b7ffbfe40d2bb5a5f58105e387eef450583eec";
    linux-armv6l = "a7bbbc80fe736269820bbdf3555e91ada5d18a5cde2276aac3b559bc1d52fc70";
    linux-loong64 = "0be34dbc69726b52414e0283736f997fee477379ebff66cebd7d8c35f4f64f9d";
    linux-mips = "bb7d7e99db7ee70063cb57bb7395c392b8b5ed87f37d733a1c91de935c70bb91";
    linux-mips64 = "c7f0571410297cb29e52d10fed7a2a21aeaeabb9539d0c04a6d778adf0fe7f1b";
    linux-mips64le = "e66c440c03dd19bf8423034cbde7f6813321beb18d3fcf2ef234c13a25467952";
    linux-mipsle = "b4e0061f62a9c1f874893aa4951a4883c19762a9dd64c5710554ec5a7aaf311a";
    linux-ppc64 = "4192158cdedc6a124aa32a099cc6bebebabf1f4d380c46c5e36ea52c30a3888b";
    linux-ppc64le = "db05b9838f69d741fb9a5301220b1a62014aee025b0baf341aba3d280087b981";
    linux-riscv64 = "aef9b186c1b9b58c0472dbf54978f97682852a91b2e8d6bf354e59ba9c24438a";
    linux-s390x = "4ab2286adb096576771801b5099760b1d625fd7b44080449151a4d9b21303672";
  };
}
