{
  lib,
  buildPythonPackage,
  openvino-native,
  numpy,
  python,
}:

buildPythonPackage {
  pname = "openvino";
  inherit (openvino-native) version;
  pyproject = false;

  src = openvino-native.python;

  propagatedBuildInputs = [ numpy ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python.sitePackages}
    cp -Rv * $out/${python.sitePackages}/

    runHook postInstall
  '';

  pythonImportsCheck = [
    "openvino"
    "openvino.runtime"
  ];

  meta = {
    description = "OpenVINO(TM) Runtime";
    homepage = "https://github.com/openvinotoolkit/openvino";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
