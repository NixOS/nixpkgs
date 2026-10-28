{ callPackage }:
callPackage ./binary.nix {
  version = "1.24.13";
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    darwin-amd64 = "6cc6549b06725220b342b740497ffd24e0ebdcef75781a77931ca199f46ad781";
    darwin-arm64 = "f282d882c3353485e2fc6c634606d85caf36e855167d59b996dbeae19fa7629a";
    freebsd-386 = "1e3bd90c1d138a3d4bbc39f3990f59faab5e9d83006b51c5dec17538716d2651";
    freebsd-amd64 = "96e3c439befbb365ecde3ae475f9319ef7693d5d66a05992e8f8d29c60a63761";
    freebsd-arm = "3d8005886f2dff23357d5d36e7759fdadc642d5207c01bd9e761d5d9e27f3257";
    freebsd-arm64 = "67efe294235fd85fc0fb810275dfd402a459c8522f7bf075f63c7047db474f1b";
    freebsd-riscv64 = "4973d786b9bc4291063ecc69546e662f18d5fa564745673c7ea39c3febc11cc3";
    linux-386 = "a55cb4587b1face90dc9334d8ad44ccd41fade77dcff645a74927eb0adc52272";
    linux-amd64 = "1fc94b57134d51669c72173ad5d49fd62afb0f1db9bf3f798fd98ee423f8d730";
    linux-arm64 = "74d97be1cc3a474129590c67ebf748a96e72d9f3a2b6fef3ed3275de591d49b3";
    linux-armv6l = "a26b1e54c0fe7b0babc79716a89b830f1cde54f6c6f914a9995d3f0d0bdd0242";
    linux-loong64 = "8fd090f77b88b9e6f3807a24fce5187163f0036a30d47abab97a1861321f62ca";
    linux-mips = "b879aea34facab984856575ddc3416cfeaa4e3b87a5b23e23ad7acb850bed605";
    linux-mips64 = "b652f8f1199fab0e139bd1e41596470cb104b404e829e658d571ad7566148ada";
    linux-mips64le = "d1c233a227fd4c5be04d4e8929b4b75e7237556916b8295c0436a1301af8ea12";
    linux-mipsle = "4685999157eafa2b731d58e93b50693c34b6efdb2a63755591e785886ca8aaf0";
    linux-ppc64 = "0ff9907f079e4f2c4d1c4a30a0acc4bb8b627a7043f49b19dc97eb4491b78fdc";
    linux-ppc64le = "5f0dfab58ce15a84d824363c041246c76847a69d14f9ffac16bd5342299ecc14";
    linux-riscv64 = "9a8166261489d3f38c7a568785b7012c123e3561779d282d568a72d58506754f";
    linux-s390x = "a3e3e2012f9b4d392fab85fd4596bbd798ea8e0ceba259f47023b8cb5ebfffc1";
  };
}
