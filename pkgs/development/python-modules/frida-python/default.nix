{
  lib,
  stdenv,
  fetchurl,
  fetchPypi,
  buildPythonPackage,
  typing-extensions,
}:
let
  version = "16.0.19";
  format = "setuptools";
  devkit = fetchurl {
    url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-linux-x86_64.tar.xz";
    hash = "sha256-yNXNqv8eCbpdQKFShpAh6rUCEuItrOSNNLOjESimPdk=";
  };
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

  propagatedBuildInputs = [ typing-extensions ];

  pythonImportsCheck = [ "frida" ];

  passthru = {
    inherit devkit;
  };

  meta = {
    description = "Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers (Python bindings)";
    homepage = "https://www.frida.re";
    license = lib.licenses.wxWindows;
    maintainers = with lib.maintainers; [ s1341 ];
    platforms = [ "x86_64-linux" ];
  };
}
