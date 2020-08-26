{ stdenv, buildPythonPackage, isPy3k, fetchPypi, pycodestyle, isort }:

buildPythonPackage rec {
  pname = "avro";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00rg1nn9szwm0p1lcda0w3iyqy9mx2y9zv0hdwaz6k0bsagziydv";
  };

  patchPhase = ''
    # this test requires network access
    sed -i 's/test_server_with_path/noop/' avro/test/test_ipc.py
  '' + (stdenv.lib.optionalString isPy3k ''
    # these files require twisted, which is not python3 compatible
    rm avro/txipc.py
    rm avro/test/txsample*
  '');

  nativeBuildInputs = [ pycodestyle ];
  propagatedBuildInputs = [ isort ];

  meta = with stdenv.lib; {
    description = "A serialization and RPC framework";
    homepage = "https://pypi.python.org/pypi/avro/";
    license = licenses.asl20;
    maintainers = [ maintainers.zimbatm ];
  };
}
