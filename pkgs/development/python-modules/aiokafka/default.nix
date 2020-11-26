{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, kafka-python
, cython
, zlib
}:

buildPythonPackage rec {
  pname = "aiokafka";
  version = "0.7.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiokafka";
    rev = "v${version}";
    sha256 = "16pcgv38syqy6sj3w7zx95zgynpd642n3i95dpiw0ivhpqrxxhrf";
  };

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    zlib
  ];

  propagatedBuildInputs = [
    kafka-python
  ];

  postPatch = ''
    substituteInPlace setup.py \
       --replace "kafka-python==1.4.6" "kafka-python"
  '';

  # checks require running kafka server
  doCheck = false;

  meta = with lib; {
    description = "Kafka integration with asyncio";
    homepage = "https://aiokafka.readthedocs.org";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
