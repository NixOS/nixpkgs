{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytest,
  runCommand,
  boringssl,
  libiconv,
  gcc-unwrapped,
  python,
  fetchpatch,
}:

let
  boringsslPatched = boringssl.overrideAttrs (oa: {
    # boringssl source obtained from https://github.com/0x676e67/boring2/tree/1a0f1cd24e728aac100df68027c820f858199224/boring-sys/deps
    src = fetchFromGitHub {
      owner = "google";
      repo = "boringssl";
      rev = "44b3df6f03d85c901767250329c571db405122d5";
      hash = "sha256-REELo7X9aFy2OHjubYLO1UQXLTgekD4QFd2vyFthIrg=";
    };
    modRoot = "./src";
    patches = [
      # A patch required to build boringssl compatible with `boring-sys2`.
      # See https://github.com/0x676e67/boring2/blob/refs/tags/v4.15.11/boring-sys/build/main.rs#L486-L489
      (fetchpatch {
        name = "boringssl-44b3df6f03d85c901767250329c571db405122d5.patch";
        url = "https://raw.githubusercontent.com/0x676e67/boring2/refs/tags/v4.15.11/boring-sys/patches/boringssl-44b3df6f03d85c901767250329c571db405122d5.patch";
        hash = "sha256-JRRATcCXo0HBQTzgCAuLpxC3NEGrTw1cEmC0VHOgO2M=";
      })
    ];

    # Remove bazel specific build file to make way for build directory
    # This is a problem on Darwin because of case-insensitive filesystem
    preBuild =
      (lib.optionalString stdenv.hostPlatform.isDarwin ''
        rm ../BUILD
      '')
      + oa.preBuild;

    env.NIX_CFLAGS_COMPILE =
      oa.env.NIX_CFLAGS_COMPILE
      + " "
      + toString (
        lib.optionals stdenv.cc.isClang [
          "-Wno-error=reorder-ctor"
        ]
        ++ lib.optionals stdenv.cc.isGNU [
          "-Wno-error=reorder"
          "-Wno-error=ignored-attributes"
        ]
      );

    vendorHash = "sha256-06MkjXl0DKFzIH/H+uT9kXsQdPq7qdZh2dlLW/YhJuk=";

    installPhase = ''
      runHook preInstall

      mkdir -p $bin/bin $dev $out/lib

      install -Dm755 tool/bssl -t $bin/bin
      install -Dm644 ssl/libssl.a -t $out/lib
      install -Dm644 crypto/libcrypto.a -t $out/lib
      install -Dm644 decrepit/libdecrepit.a -t $out/lib

      cp -r ../include $dev

      runHook postInstall
    '';
  });
  # boring-sys expects the static libraries in build/ instead of lib/
  boringssl-wrapper = runCommand "boringssl-wrapper" { } ''
    mkdir $out
    ln -s ${boringsslPatched.out}/lib $out/build
    ln -s ${boringsslPatched.dev}/include $out/include
  '';
in
buildPythonPackage rec {
  pname = "primp";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "primp";
    tag = "v${version}";
    hash = "sha256-13o0Ni0dvZaoKgYy2cFQhebwKAJGm5Z2s+gVAddxYxU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-UBpf9f3wJgbizHERsm83cuKHiMixj/8JX/IGvteySIo=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  # TODO: Can we improve this?
  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.getLib gcc-unwrapped.lib} --add-needed libstdc++.so.6 $out/${python.sitePackages}/primp/primp.abi3.so
  '';

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  env.BORING_BSSL_PATH = boringssl-wrapper;
  env.BORING_BSSL_ASSUME_PATCHED = true;

  optional-dependencies = {
    dev = [ pytest ];
  };

  # Test use network
  doCheck = false;

  pythonImportsCheck = [ "primp" ];

  meta = {
    changelog = "https://github.com/deedy5/primp/releases/tag/${version}";
    description = "Python Requests IMPersonate, the fastest Python HTTP client that can impersonate web browsers";
    homepage = "https://github.com/deedy5/primp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
