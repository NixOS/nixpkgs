{ lib, buildPythonPackage, isPy3k, fetchPypi, pycodestyle, isort }:

buildPythonPackage rec {
  pname = "avro";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3a405df5aa8654b992d2aca7b80482b858a1919a44dc0b10a682162e8ee340a";
  };

  patchPhase = ''
    # this test requires network access
    sed -i 's/test_server_with_path/noop/' avro/test/test_ipc.py
  '' + (lib.optionalString isPy3k ''
    # these files require twisted, which is not python3 compatible
    rm avro/txipc.py
    rm avro/test/txsample*
  '');

  nativeBuildInputs = [ pycodestyle ];
  propagatedBuildInputs = [ isort ];

  meta = with lib; {
    description = "A serialization and RPC framework";
    homepage = "https://pypi.python.org/pypi/avro/";
    license = licenses.asl20;
    maintainers = [ maintainers.zimbatm ];
  };
}
