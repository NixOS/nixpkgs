{ runCommandNoCC, python }:

runCommandNoCC "pynvml-gpu-test"
  {
    nativeBuildInputs = [ (python.withPackages (ps: [ ps.pynvml ])) ];
    requiredSystemFeatures = [ "cuda" ];
  }
  ''
    python3 << EOF
    import pynvml
    from pynvml.smi import nvidia_smi

    pynvml.nvmlInit()
    EOF

    touch $out
  ''
