{ lib, buildPythonPackage, fetchFromGitHub, isPy27, pythonAtLeast
, Keras, numpy, scipy, six, tensorflow }:

buildPythonPackage rec {
  pname = "edward";
  version = "1.3.5";

  disabled = !(isPy27 || pythonAtLeast "3.4");

  src = fetchFromGitHub {
     owner = "blei-lab";
     repo = "edward";
     rev = "1.3.5";
     sha256 = "0v1ng40rvya1wc7vk6piv2wiaf830mib8ij0qgm17n3ld4ai4in6";
  };

  # disabled for now due to Tensorflow trying to create files in $HOME:
  doCheck = false;

  propagatedBuildInputs = [ Keras numpy scipy six tensorflow ];

  meta = with lib; {
    description = "Probabilistic programming language using Tensorflow";
    homepage = "https://github.com/blei-lab/edward";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
