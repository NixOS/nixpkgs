{ python3Packages, runCommand }:

runCommand "${python3Packages.opencv4.pname}-libstdcxx-test"
{
  nativeBuildInputs = [
    (python3Packages.python.withPackages (ps: with ps; [
      (opencv4.override { enableCuda = true; })
      scikit-image
    ]))
  ];
} ''
  python << EOF
  import cv2
  from skimage.transform import pyramid_reduce
  EOF
  touch $out
''
