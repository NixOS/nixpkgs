{ lib, buildPythonPackage, fetchPypi
, mock, jinja2, click, terminaltables
}:

buildPythonPackage rec {
  pname = "envs";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ccf5cd85ddb8ed335e39ed8a22e0d23658f5a6d7da430f225e6f750c6f50ae42";
  };

  checkInputs = [ mock jinja2 click terminaltables ];

  meta = with lib; {
    description = "Easy access to environment variables from Python";
    homepage = https://github.com/capless/envs;
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
