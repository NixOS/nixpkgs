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
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "306145b8683e016d81aea996bcaefee648483fc5a9eb4694bb488f54df54a751";
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
