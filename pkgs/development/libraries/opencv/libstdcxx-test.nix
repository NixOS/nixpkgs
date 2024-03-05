{ python3Packages, runCommand, attrName }:

runCommand "${python3Packages.${attrName}.name}-libstdcxx-test"
{
  nativeBuildInputs = [
    (python3Packages.python.withPackages (ps: [
      (ps.${attrName}.override { enableCuda = true; })
      ps.scikit-image
    ]))
  ];
} ''
  python << EOF
  import cv2
  from skimage.transform import pyramid_reduce
  EOF
  touch $out
''
