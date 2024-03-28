{ type }:
assert builtins.elem type [ "sgx" ];

{ lib
, gdb
, gccStdenv
, cmake
, llvmPackages_8
, fetchurl
, fetchFromGitHub
, openssl
, perl
, valgrind
, doxygen
, python3
}:
let
  intelTools = rec {
    version = "2.13";
    src = fetchurl {
      url = "https://download.01.org/intel-sgx/sgx-linux/${version}/as.ld.objdump.gold.r3.tar.gz";
      sha256 = "sha256-eUljypD7BWHK8+0r7h2bo5QibzVWic3aKBYebgYgpxM=";
    };
  };

  clang = llvmPackages_8.clang;
in
llvmPackages_8.stdenv.mkDerivation rec {
  pname = "openenclave-${type}";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "openenclave";
    repo = "openenclave";
    rev = "v${version}";
    sha256 = "sha256-ffXDVEmTeqNvYJ497LGV8NONu/CibfCZ8+nNsjrONOs=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs 3rdparty/musl/append-deprecations 3rdparty/openssl/append-unsupported \
      tests/crypto/data/make-test-certs tests/crypto_crls_cert_chains/data/make-test-certs \
      scripts/lvi-mitigation/generate_wrapper scripts/lvi-mitigation/invoke_compiler

    substituteInPlace debugger/oegdb \
        --replace 'gdb -iex' '${gdb}/bin/gdb -iex'
    substituteInPlace scripts/lvi-mitigation/invoke_compiler \
        --replace '/usr/bin/"$compiler"' '"$compiler"' \
        --replace 'export PATH=/bin:/usr/local:"$lvi_bin_path"' 'export PATH=$PATH:"$lvi_bin_path"'
  '';

  preConfigure =
    let
      mkWrapper = name: ''
        scripts/lvi-mitigation/generate_wrapper --name=${name} --path=lvi_mitigation_bin
        patchShebangs lvi_mitigation_bin/${name}
      '';
    in
    ''
      mkdir -p lvi_mitigation_bin
      tar -zxf ${intelTools.src} -C lvi_mitigation_bin/
      cp scripts/lvi-mitigation/invoke_compiler lvi_mitigation_bin/

      ln -s ${gccStdenv}/bin/gcc lvi_mitigation_bin/gcc_symlink
      ln -s ${gccStdenv}/bin/g++ lvi_mitigation_bin/g++_symlink

      ln -s ${clang}/bin/clang lvi_mitigation_bin/clang_symlink
      ln -s ${clang}/bin/clang++ lvi_mitigation_bin/clang++_symlink

      ${mkWrapper "gcc"}
      ${mkWrapper "g++"}

      ${mkWrapper "clang"}
      ${mkWrapper "clang++"}
    '';

  buildInputs = [ openssl ];

  nativeBuildInputs = [
    gccStdenv
    llvmPackages_8.clang
    cmake
    perl
    valgrind
    doxygen
    python3
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    #"-DENABLE_FULL_LIBCXX_TESTS=ON"
    #"-DENABLE_FULL_STRESS_TESTS=ON"
    "-DENABLE_REFMAN=ON"

    "-DLVI_MITIGATION=ControlFlow"
    "-DLVI_MITIGATION_BINDIR=/build/source/lvi_mitigation_bin"
  ];

  # required, otherwise we fail on -nostdinc++
  NIX_CFLAGS_COMPILE = "-Wno-unused-command-line-argument";

  meta = with lib; {
    description = "A hardware-agnostic open source library for developing applications that utilize Hardware-based Trusted Execution Environments";
    homepage = "https://openenclave.io";
    license = licenses.mit;
    maintainers = with maintainers; [ citadelcore ];
  };
}
