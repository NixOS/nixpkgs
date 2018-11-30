{ stdenv, buildPythonPackage, fetchFromGitHub
, pybluez }:

buildPythonPackage rec {
  pname = "bt-proximity";
  version = "0.0.20180217";

  # pypi only has a pre-compiled wheel and no sources
  src = fetchFromGitHub {
    owner  = "FrederikBolding";
    repo   = "bluetooth-proximity";
    rev    = "463bade8a9080b47f09bf4a47830b31c69c5dffd";
    sha256 = "0anfh90cj3c2g7zqrjvq0d6dzpb4hjl6gk8zw0r349j2zw9i4h7y";
  };

  propagatedBuildInputs = [ pybluez ];

  # there are no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Bluetooth Proximity Detection using Python";
    homepage = https://github.com/FrederikBolding/bluetooth-proximity;
    maintainers = with maintainers; [ peterhoeg ];
    license = licenses.asl20;
  };
}
