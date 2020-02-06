{ lib
, buildPythonPackage
, fetchFromGitHub
, pamqp
, pytest
, asynctest
, pyrabbit2
, isPy27
}:

buildPythonPackage rec {
  pname = "aioamqp";
  version = "0.14.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "Polyconseil";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1gpfsrc2vi6w33c9zsycd2qn589pr7a222rb41r85m915283zy48";
  };

  propagatedBuildInputs = [
    pamqp
  ];

  checkInputs = [
    pytest
    asynctest
    pyrabbit2
  ];

  # tests assume rabbitmq server running
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/polyconseil/aioamqp;
    description = "AMQP implementation using asyncio";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
