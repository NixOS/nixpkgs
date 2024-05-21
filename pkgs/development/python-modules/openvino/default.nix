{ lib
, buildPythonPackage
, openvino-native
, numpy
, python
}:

buildPythonPackage {
  pname = "openvino";
  inherit (openvino-native) version;
  format = "other";

  src = openvino-native.python;

  propagatedBuildInputs = [
    numpy
  ];

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

  meta = with lib; {
    description = "OpenVINO(TM) Runtime";
    homepage = "https://github.com/openvinotoolkit/openvino";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
