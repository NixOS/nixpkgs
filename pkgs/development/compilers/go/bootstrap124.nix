{ callPackage }:
callPackage ./binary.nix {
  version = "1.24.11";
  hashes = {
    # Use `print-hashes.sh ${version}` to generate the list below
    darwin-amd64 = "c45566cf265e2083cd0324e88648a9c28d0edede7b5fd12f8dc6932155a344c5";
    darwin-arm64 = "a9c90c786e75d5d1da0547de2d1199034df6a4b163af2fa91b9168c65f229c12";
    freebsd-386 = "99229da13fd74d5cdcb81fae844bf48574c64eae0d2821137f45c848f1453771";
    freebsd-amd64 = "de6fdd4eefa06dbb2531ed601ef5f2b88e73f49f89c10bc1078f51a96a7ae88f";
    freebsd-arm = "fd7a01515c09ad190c969bd9cd277803c05acfaa7b03c496d3a9d1b8cad72d03";
    freebsd-arm64 = "eead4408b88557228fe4b30ee90aa33062d338fa5647c046a5aaca4237839f5a";
    freebsd-riscv64 = "3c192d96d57c6330e6a92d70235a4e938345c9b3a50d37cfce60c92dd7240d04";
    linux-386 = "bb702d0b67759724dccee1825828e8bae0b5199e3295cac5a98a81f3098fa64a";
    linux-amd64 = "bceca00afaac856bc48b4cc33db7cd9eb383c81811379faed3bdbc80edb0af65";
    linux-arm64 = "beaf0f51cbe0bd71b8289b2b6fa96c0b11cd86aa58672691ef2f1de88eb621de";
    linux-armv6l = "24d712a7e8ea2f429c05bc67287249e0291f2fe0ea6d6ff268f11b7343ad0f47";
    linux-loong64 = "45c3cbec9e30071ea1f3323fc30fb1b8497007c992f00ba48fcdcb729f06467c";
    linux-mips = "c006942d74a348af080aac3930c3772148761cf1de5d97c3879c30d17b72ccf5";
    linux-mips64 = "d054e2fb0873ac1d5502c4a860090bfff130b8fabdeeea311adda658fbc45ac5";
    linux-mips64le = "c0274255613b85e2ba45e210e8f07995d51a048f11c7f0b9128dc177472692b3";
    linux-mipsle = "5c787fc3ac04c4ebeaa0a6602c8a69eae557fe15d033a07cf22ac44e2489285f";
    linux-ppc64 = "3fceb9492469f2155134a834c12b4bf9c1126fbb3cbf5a5ae660648897b8076d";
    linux-ppc64le = "f770d0c5d7e7e2edb030133ac7854d9204f4e954e79a176e81362ffedf6ea34c";
    linux-riscv64 = "9db9ba8e6b60f3662f55ed78b128175edbe8b9480e657126a5b8f5043ee1e38c";
    linux-s390x = "5955ddda3445b2cbfd81b8772044084911f55d0baeb32414da0411f6a377a2d4";
  };
}
