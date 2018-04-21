{ lib, buildPythonPackage, fetchFromGitHub
, click, jinja2, terminaltables }:

buildPythonPackage rec {
  pname = "envs";
  version = "1.2.4";

  # move to fetchPyPi when https://github.com/capless/envs/issues/8 is fixed
  src = fetchFromGitHub {
    owner  = "capless";
    repo   = "envs";
    rev    = "e1f6cbad7f20316fc44324d2c50826d57c2817a8";
    sha256 = "0p88a79amj0jxll3ssq1dzg78y7zwgc8yqyr7cf53nv2i7kmpakv";
  };

  checkInputs = [ click jinja2 terminaltables ];

  meta = with lib; {
    description = "Easy access to environment variables from Python";
    homepage = https://github.com/capless/envs;
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
