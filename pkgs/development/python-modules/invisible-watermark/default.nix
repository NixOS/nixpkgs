{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  opencv-python,
  torch,
  onnx,
  onnxruntime,
  pillow,
  pywavelets,
  numpy,
  callPackage,
  withOnnx ? false, # Enables the rivaGan en- and decoding method
}:

buildPythonPackage rec {
  pname = "invisible-watermark";
  version = "0.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ShieldMnt";
    repo = "invisible-watermark";
    rev = "e58e451cff7e092457cd915e445b1a20b64a7c8f"; # No git tag, see https://github.com/ShieldMnt/invisible-watermark/issues/22
    hash = "sha256-6SjVpKFtiiLLU7tZ3hBQr0KT/YEQyywJj0e21/dJRzk=";
  };

  propagatedBuildInputs =
    [
      opencv-python
      torch
      pillow
      pywavelets
      numpy
    ]
    ++ lib.optionals withOnnx [
      onnx
      onnxruntime
    ];

  postPatch = ''
    substituteInPlace imwatermark/rivaGan.py --replace \
      'You can install it with pip: `pip install onnxruntime`.' \
      'You can install it with an override: `python3Packages.invisible-watermark.override { withOnnx = true; };`.'
  '';

  passthru.tests =
    let
      image = "${src}/test_vectors/original.jpg";
      methods = [
        "dwtDct"
        "dwtDctSvd"
        "rivaGan"
      ];
      testCases = builtins.concatMap (method: [
        {
          method = method;
          withOnnx = true;
        }
        {
          method = method;
          withOnnx = false;
        }
      ]) methods;
      createTest =
        { method, withOnnx }:
        let
          testName = "${if withOnnx then "withOnnx" else "withoutOnnx"}-${method}";
          # This test fails in the sandbox on aarch64-linux, see https://github.com/microsoft/onnxruntime/issues/10038
          skipTest =
            stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64 && withOnnx && method == "rivaGan";
        in
        lib.optionalAttrs (!skipTest) {
          "${testName}" = callPackage ./tests/cli.nix {
            inherit
              image
              method
              testName
              withOnnx
              ;
          };
        };
      allTests = builtins.map createTest testCases;
    in
    (lib.attrsets.mergeAttrsList allTests)
    // {
      python = callPackage ./tests/python { inherit image; };
    };

  pythonImportsCheck = [ "imwatermark" ];

  meta = with lib; {
    description = "Library for creating and decoding invisible image watermarks";
    mainProgram = "invisible-watermark";
    homepage = "https://github.com/ShieldMnt/invisible-watermark";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
