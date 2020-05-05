{ lib, buildPythonPackage, isPy27, fetchPypi }:

buildPythonPackage rec {
  pname = "pyln-client";
  version = "0.8.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "16l8d9fy8nq5b66nmw8l31z9js4l0mxiw9mcrg3k8myd9p34l9l3";
  };

  # the distribution lacks requirements.txt file, it should be empty
  postPatch = ''
    touch requirements.txt
  '';

  meta = with lib; {
    description = "Client library for lightningd";
    homepage = https://github.com/ElementsProject/lightning;
    license = licenses.mit;
    maintainers = with maintainers; [ zhenyavinogradov ];
  };
}
