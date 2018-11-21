{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, nose
, mock
, pyyaml
, unittest2
, pyev
, twisted
, tornado
}:

buildPythonPackage rec {
  pname = "pika";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nb4h08di432lv7dy2v9kpwgk0w92f24sqc2hw2s9vwr5b8v8xvj";
  };

  # Tests require twisted which is only availalble for python-2.x
  doCheck = !isPy3k;

  buildInputs = [ nose mock pyyaml unittest2 pyev ]
    ++ stdenv.lib.optionals (!isPy3k) [ twisted tornado ];

  meta = with stdenv.lib; {
    description = "Pure-Python implementation of the AMQP 0-9-1 protocol";
    homepage = https://pika.readthedocs.org;
    license = licenses.bsd3;
  };

}
