{ lib, fetchPypi, buildPythonPackage, cffi }:
buildPythonPackage rec {
  pname = "misaka";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yqrq3a5rracirmvk52n28nn6ckdaz897gnigv89a9gmyn87sqw7";
  };

  propagatedBuildInputs = [ cffi ];

  # The tests require write access to $out
  doCheck = false;

  meta = with lib; {
    description = "A CFFI binding for Hoedown, a markdown parsing library";
    homepage = http://misaka.61924.nl/;
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
