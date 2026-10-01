{
  lib,
  buildPythonPackage,
  openvino-genai-native,
  numpy,
  openvino-tokenizers,
  python,
}:

buildPythonPackage {
  pname = "openvino-genai";
  inherit (openvino-genai-native) version;
  pyproject = false;

  src = openvino-genai-native.python;

  dependencies = [
    numpy
    # openvino-genai loads tokenizers via py::module_::import("openvino_tokenizers")
    # at runtime, so the Python wrapper must be available on the import path.
    openvino-tokenizers
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python.sitePackages}
    cp -R * $out/${python.sitePackages}/

    runHook postInstall
  '';

  pythonImportsCheck = [ "openvino_genai" ];

  meta = {
    description = "OpenVINO GenAI Python API";
    homepage = "https://github.com/openvinotoolkit/openvino.genai";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpds ];
  };
}
