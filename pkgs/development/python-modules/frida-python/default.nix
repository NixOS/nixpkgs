{
  lib,
  stdenv,
  fetchurl,
  fetchPypi,
  buildPythonPackage,
  typing-extensions,
  darwin,
}:
let
  version = "16.0.19";
  format = "setuptools";

  devkit = {
    aarch64-darwin = fetchurl {
      url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-macos-arm64.tar.xz";
      hash = "sha256-5VAZnpHQ5wjl7IM96GhIKOfFYHFDKKOoSjN1STna2UA=";
    };

    x86_64-linux = fetchurl {
      url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-linux-x86_64.tar.xz";
      hash = "sha256-yNXNqv8eCbpdQKFShpAh6rUCEuItrOSNNLOjESimPdk=";
    };
  }.${stdenv.hostPlatform.system}
    or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
buildPythonPackage rec {
  pname = "frida-python";
  inherit version;

  src = fetchPypi {
    pname = "frida";
    inherit version;
    hash = "sha256-rikIjjn9wA8VL/St/2JJTcueimn+q/URbt9lw/+nalY=";
  };

  postPatch = ''
    mkdir assets
    pushd assets
    tar xvf ${devkit}
    export FRIDA_CORE_DEVKIT=$PWD
    popd
  '';

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework AppKit";

  propagatedBuildInputs = [ typing-extensions ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  pythonImportsCheck = [ "frida" ];

  passthru = {
    inherit devkit;
  };

  meta = {
    description = "Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers (Python bindings)";
    homepage = "https://www.frida.re";
    license = lib.licenses.wxWindows;
    maintainers = with lib.maintainers; [ s1341 ];
    platforms = [ "aarch64-darwin" "x86_64-linux" ];
  };
}
