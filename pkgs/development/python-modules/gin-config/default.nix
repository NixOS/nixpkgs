{ lib
, buildPythonPackage
, fetchPypi
, six
, enum34
, absl-py
, tensorflow
}:

buildPythonPackage rec {
  pname = "gin-config";
  version = "0.1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zqzhg8nqdqjx0sjrsrs9bpyiaqqlyihqhhy2ijrpp62x9rjllga";

  };

  buildInputs = [ six enum34 tensorflow ];
  checkInputs = [ absl-py tensorflow ];

  meta = with lib; {
    homepage = https://github.com/google/gin-config;
    description = "Gin provides a lightweight configuration framework for Python, based on dependency injection.";
    license = licenses.asl20;
    maintainers = with maintainers; [ jethrokuan ];
  };
}
