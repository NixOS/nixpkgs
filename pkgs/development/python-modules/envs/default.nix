{ lib, buildPythonPackage, fetchPypi
, click, jinja2, terminaltables }:

buildPythonPackage rec {
  pname = "envs";
  version = "1.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5fe059d6df1ae01c422d32b10ec7f539baad0e7d339f4c8b2de4ad8cbb07c8ba";
  };

  checkInputs = [ click jinja2 terminaltables ];

  meta = with lib; {
    description = "Easy access to environment variables from Python";
    homepage = https://github.com/capless/envs;
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
