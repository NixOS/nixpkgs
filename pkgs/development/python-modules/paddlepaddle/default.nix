{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, pythonAtLeast
, autoPatchelfHook
, openssl_1_1
, zlib
, setuptools
, cudaSupport ? false
, cudaPackages_11 ? {}
# runtime dependencies
, httpx
, numpy
, protobuf
, pillow
, decorator
, astor
, paddle-bfloat
, opt-einsum
}:

let
  pname = "paddlepaddle${if cudaSupport then "_gpu" else ""}";
  version = "2.5.0";
  format = "wheel";
  pyShortVersion = "cp${builtins.replaceStrings ["."] [""] python.pythonVersion}";
  hashAndPlatform = import ./binary-hashes.nix {
    inherit cudaSupport;
    pythonVersion = pyShortVersion;
    system = stdenv.system;
  };
  src = fetchPypi ({
    inherit pname version format;
    dist = pyShortVersion;
    python = pyShortVersion;
    abi = pyShortVersion;
  } // hashAndPlatform);
in
buildPythonPackage {
  inherit pname version format src;

  disabled = pythonOlder "3.9" || pythonAtLeast "3.11";

  libraryPath = lib.makeLibraryPath (
    # TODO: remove openssl_1_1 and zlib, maybe by building paddlepaddle from
    # source as suggested in the following comment:
    # https://github.com/NixOS/nixpkgs/pull/243583#issuecomment-1641450848
    [ openssl_1_1 zlib ] ++ lib.optionals cudaSupport (with cudaPackages_11; [
      cudatoolkit.lib
      cudatoolkit.out
      cudnn
    ])
  );

  postFixup = lib.optionalString stdenv.isLinux ''
    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      patchelf --set-rpath "$p:$libraryPath" $1
    }

    fixRunPath $out/lib/python${python.pythonVersion}/site-packages/paddle/fluid/libpaddle.so
  '';

  buildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    httpx
    numpy
    protobuf
    pillow
    decorator
    astor
    paddle-bfloat
    opt-einsum
  ];

  pythonImportsCheck = [ "paddle" ];

  meta = with lib; {
    description = "PArallel Distributed Deep LEarning: Machine Learning Framework from Industrial Practice （『飞桨』核心框架，深度学习&机器学习高性能单机、分布式训练和跨平台部署";
    homepage = "https://github.com/PaddlePaddle/Paddle";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = [ "x86_64-linux" ] ++ optionals (!cudaSupport) [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
