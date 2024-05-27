{ callPackage }:
callPackage ./binary.nix {
  version = "1.21.0";
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    darwin-amd64 = "b314de9f704ab122c077d2ec8e67e3670affe8865479d1f01991e7ac55d65e70";
    darwin-arm64 = "3aca44de55c5e098de2f406e98aba328898b05d509a2e2a356416faacf2c4566";
    linux-386 = "0e6f378d9b072fab0a3d9ff4d5e990d98487d47252dba8160015a61e6bd0bcba";
    linux-amd64 = "d0398903a16ba2232b389fb31032ddf57cac34efda306a0eebac34f0965a0742";
    linux-arm64 = "f3d4548edf9b22f26bbd49720350bbfe59d75b7090a1a2bff1afad8214febaf3";
    linux-armv6l = "e377a0004957c8c560a3ff99601bce612330a3d95ba3b0a2ae144165fc87deb1";
    linux-loong64 = "e484cdc55221f7e7853666ed4f0ef462eef46b52253f84df60a7b908416060cb";
    linux-mips = "6311d8ccd6ff9ce3cc8ecc72017d651d23e7325943fa72f4b65cd750be8aacd8";
    linux-mips64 = "6d9cb425dc61f60bff41e2dec873abbcc5b8dbd1d32997f994d707b662f3c363";
    linux-mips64le = "92f7933d997c589b4f506c6b3cc5b27ff43b294c3a2d40bf4d7eeaf375f92afb";
    linux-mipsle = "9bb9f938457411042074a57284d40a086e63f7778f86e1632e018bbc38948c92";
    linux-ppc64 = "e34dcc1df804bf8bac035ace3304f23696a9138a79a398dce981d89072d3ae23";
    linux-ppc64le = "e938ffc81d8ebe5efc179240960ba22da6a841ff05d5cab7ce2547112b14a47f";
    linux-riscv64 = "87b21c06573617842ca9e00b954bc9f534066736a0778eae594ac54b45a9e8b7";
    linux-s390x = "be7338df8e5d5472dfa307b0df2b446d85d001b0a2a3cdb1a14048d751b70481";
  };
}
