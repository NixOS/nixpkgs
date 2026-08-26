{
  lib,
  buildPythonPackage,
  openvino-native,
  numpy,
  packaging,
}:

buildPythonPackage {
  pname = "openvino";
  inherit (openvino-native) version;
  pyproject = false;

  src = openvino-native.python;

  dependencies = [
    numpy
    packaging
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -Rv * $out/

    runHook postInstall
  '';

  pythonImportsCheck = [
    "openvino"
  ];

  meta = {
    description = "OpenVINO(TM) Runtime";
    homepage = "https://github.com/openvinotoolkit/openvino";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
