{
  lib,
  buildPythonPackage,
  openvino,
  openvino-tokenizers-native,
  python,
}:

buildPythonPackage {
  pname = "openvino-tokenizers";
  inherit (openvino-tokenizers-native) version;
  pyproject = false;

  src = openvino-tokenizers-native.src;

  dependencies = [ openvino ];

  installPhase = ''
    runHook preInstall

    target=$out/${python.sitePackages}/openvino_tokenizers
    mkdir -p $target/lib
    cp -r python/openvino_tokenizers/. $target/

    # __version__.py ships with a placeholder; py-build-cmake normally rewrites
    # it at configure time. We're not using py-build-cmake, so substitute here.
    substituteInPlace $target/__version__.py \
      --replace-fail '0.0.0.0' '${openvino-tokenizers-native.version}'

    # Place the extension where __init__.py looks for it
    # (<site-packages>/openvino_tokenizers/lib/libopenvino_tokenizers.so).
    cp ${openvino-tokenizers-native}/lib/libopenvino_tokenizers.so $target/lib/

    runHook postInstall
  '';

  pythonImportsCheck = [ "openvino_tokenizers" ];

  meta = {
    description = "OpenVINO Tokenizers Python API";
    homepage = "https://github.com/openvinotoolkit/openvino_tokenizers";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpds ];
  };
}
