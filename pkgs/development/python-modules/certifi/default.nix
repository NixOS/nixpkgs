{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2018.11.29";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dvccavd2fzq4j37w0sznylp92ps14zi6gvlxzm23in0yhzciya7";
  };

  meta = {
    homepage = http://certifi.io/;
    description = "Python package for providing Mozilla's CA Bundle";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ koral ];
  };
}
