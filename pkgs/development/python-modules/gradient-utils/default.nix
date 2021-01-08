{ lib, fetchPypi, buildPythonPackage, hyperopt, wheel, prometheus_client, numpy }:

buildPythonPackage rec {
  pname = "gradient-utils";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "tbSo1TX9PzCvXgBf49HPlHLFclql/Yo9IMSdNQytyaU=";
  };

  nativeBuildInputs = [ wheel ];
  propagatedBuildInputs = [ hyperopt prometheus_client numpy ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "numpy = \"1.19.3\"" "numpy"
    substituteInPlace setup.py \
      --replace "numpy==1.19.3" "numpy"
  '';

  pythonImportsCheck = [ "gradient_utils" ];

  meta = with lib; {
    description = "Python utils and helpers library for Gradient";
    homepage    = "https://github.com/Paperspace/gradient-utils";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
