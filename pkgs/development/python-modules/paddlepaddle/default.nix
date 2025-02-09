{ stdenv
, config
, lib
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, pythonAtLeast
, openssl_1_1
, zlib
, setuptools
, cudaSupport ? config.cudaSupport or false
, cudaPackages_11 ? {}
, addOpenGLRunpath
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
  pname = "paddlepaddle" + lib.optionalString cudaSupport "-gpu";
  version = "2.5.0";
  format = "wheel";
  pyShortVersion = "cp${builtins.replaceStrings ["."] [""] python.pythonVersion}";
  allHashAndPlatform = import ./binary-hashes.nix;
  hash = allHashAndPlatform."${stdenv.system}"."${if cudaSupport then "gpu" else "cpu"}"."${pyShortVersion}";
  platform = allHashAndPlatform."${stdenv.system}".platform;
  src = fetchPypi ({
    inherit version format hash platform;
    pname = builtins.replaceStrings [ "-" ] [ "_" ] pname;
    dist = pyShortVersion;
    python = pyShortVersion;
    abi = pyShortVersion;
  });
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
      ${lib.optionalString cudaSupport ''
        addOpenGLRunpath $1
      ''}
    }
    fixRunPath $out/${python.sitePackages}/paddle/fluid/libpaddle.so
  '';

  nativeBuildInputs = [
    addOpenGLRunpath
  ];

  propagatedBuildInputs = [
    setuptools
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

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "PArallel Distributed Deep LEarning: Machine Learning Framework from Industrial Practice （『飞桨』核心框架，深度学习&机器学习高性能单机、分布式训练和跨平台部署";
    homepage = "https://github.com/PaddlePaddle/Paddle";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = [ "x86_64-linux" ] ++ optionals (!cudaSupport) [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
