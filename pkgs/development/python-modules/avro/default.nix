{ lib, buildPythonPackage, isPy3k, fetchPypi, pycodestyle, isort }:

buildPythonPackage rec {
  pname = "avro";
  version = "1.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "381b990cc4c4444743c3297348ffd46e0c3a5d7a17e15b2f4a9042f6e955c31a";
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
