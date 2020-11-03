{ stdenv, buildPythonPackage, isPy3k, fetchPypi, pycodestyle, isort }:

buildPythonPackage rec {
  pname = "avro";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbf9f89fd20b4cf3156f10ec9fbce83579ece3e0403546c305957f9dac0d2f03";
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
  requiredPythonModules = [ isort ];

  meta = with stdenv.lib; {
    description = "A serialization and RPC framework";
    homepage = "https://pypi.python.org/pypi/avro/";
    license = licenses.asl20;
    maintainers = [ maintainers.zimbatm ];
  };
}
