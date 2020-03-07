{ stdenv, lib, buildPythonPackage, fetchPypi, pythonOlder, python
, cffi, click, numpy, pyyaml, pillow, six, future, tensorflow-tensorboard
, protobuf, openmpi, typing, requests
, cudatoolkit, cudnn, addOpenGLRunpath }:

let
  cpython = "cp${python.sourceVersion.major}${python.sourceVersion.minor}";
  sha256 = {
    cp27 = "1hc2yvkmdalvvm08g3lvl6w64z2452q4k20gadydavnz8hg4s797";
    cp35 = "0a8qbzsmcxqp9s8vbzr39hlikj4n86gszx14gi1mlpp8iq76ml2l";
    cp36 = "1g3xcrzkbyjal1r8v70ljzmxrf7zs1ijbg842ln79jwym8sg6ml8";
    cp37 = "0a4xkg3fiiwxgwqb5fb77dan9k008ahmx9hdnpj1ck27gfzh7zwg";
    cp38 = "0y0p8fpbxphkzqk1wbrm3r0h9zrx8r3c8hra9imbllb0pk31ajah";
  }."${cpython}";
in buildPythonPackage rec {
  pname = "pytorch";
  version = "1.4.0";

  format = "wheel";

  src = fetchPypi {
    inherit format version sha256;
    pname = "torch";

    python = cpython;
    abi = if cpython == "cp38"
      then cpython
      else "${cpython}m";
    platform = "manylinux1_x86_64";
  };

  nativeBuildInputs = [ addOpenGLRunpath ];

  propagatedBuildInputs = [
    cffi click numpy pyyaml
    # openmpi support
    openmpi
    # the following are required for tensorboard support
    pillow six future tensorflow-tensorboard protobuf
    # other?
    requests
  ] ++ lib.optional (pythonOlder "3.5") typing;

  dontStrip = true;
  dontPatchELF = true;

  postFixup = let
    cuda_paths = [
      cudatoolkit.out
      cudatoolkit.lib
      cudnn
      # nvidia_x11
    ];

    base_lib_paths = [
      stdenv.cc.cc.lib
    ];

    rpath = lib.makeLibraryPath (base_lib_paths ++ cuda_paths);
  in ''
    rrPathArr=(
      "$out/${python.sitePackages}/torch/lib"
      "$out/${python.sitePackages}/torch"
      "$out/${python.sitePackages}/caffe2/python"
      "${rpath}"
    )

    # The the bash array into a colon-separated list of RPATHs.
    rrPath=$(IFS=$':'; echo "''${rrPathArr[*]}")
    echo "patching with the following rpath: $rrPath"

    find $out/${python.sitePackages} -type f -executable | while read lib; do
      echo "patching $lib..."
      chmod a+rx "$lib"
      patchelf --set-rpath "$rrPath" "$lib"
      addOpenGLRunpath "$lib"
    done
  '';

  pythonImportsCheck = [
    "torch"
    "torch.nn"
    "torch.nn.functional"
    # "torch.Tensor"
    # Tensor Attributes
    "torch.autograd"
    "torch.cuda"
    "torch.distributed"
    "torch.distributions"
    "torch.hub"
    "torch.jit"
    "torch.nn.init"
    "torch.onnx"
    "torch.optim"
    # Quantization
    # Distributed RPC Framework
    "torch.random"
    "torch.sparse"
    # "torch.Storage"
    "torch.utils.bottleneck"
    "torch.utils.checkpoint"
    "torch.utils.cpp_extension"
    "torch.utils.data"
    "torch.utils.dlpack"
    "torch.utils.model_zoo"
    "torch.utils.tensorboard"
    # Type Info
    # Named Tensors
    # Named Tensors operator coverage
    # torch.__config__
  ];

  meta = with lib; {
    description = "Open source, prototype-to-production deep learning platform";
    homepage    = https://pytorch.org/;
    license     = licenses.bsd3;
    platforms   = [ "x86_64-linux" ];
    maintainers = with maintainers; [ eadwu ];
  };
}
