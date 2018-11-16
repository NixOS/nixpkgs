{ lib, buildPythonPackage, isPy3k, fetchPypi, h2, priority }:

buildPythonPackage rec {
  pname = "aioh2";
  version = "0.2.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "03i24wzpw0mrnrpck3w6qy83iigwl7n99sdrndqzxfyrc69b99wd";
  };

  propagatedBuildInputs = [ h2 priority ];

  doCheck = false; # https://github.com/decentfox/aioh2/issues/17

  meta = with lib; {
    homepage = https://github.com/decentfox/aioh2;
    description = "HTTP/2 implementation with hyper-h2 on Python 3 asyncio";
    license = licenses.bsd3;
    maintainers = [ maintainers.qyliss ];
  };
}
